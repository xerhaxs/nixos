{
  config,
  lib,
  pkgs,
  weishaupt-modbus,
  weishaupt-webif-api-src,
  ...
}:

let
  cfg = config.nixos.server.management.homeassistant;
  haPython = pkgs.home-assistant.python3Packages;

  weishaupt-webif-api = haPython.buildPythonPackage {
    pname = "weishaupt-webif-api";
    version = (lib.importTOML "${weishaupt-webif-api-src}/pyproject.toml").project.version;
    pyproject = true;

    src = weishaupt-webif-api-src;

    build-system = [ haPython.setuptools ];

    dependencies = with haPython; [
      httpx
      beautifulsoup4
    ];

    pythonImportsCheck = [ "weishaupt_webif_api" ];
  };

  # 1. ntfy (reaches every listening host, also away from home), 2. ssh to the hosts in the LAN
  # (without internet), 3. NixOS-Server1 itself through /run/killswitch. A failing step does not stop
  # the next one.
  killswitchScript = pkgs.writeShellScript "killswitch-publish" ''
    set -a; . ${config.sops.secrets."killswitch/ha-env".path}; set +a
    ${pkgs.curl}/bin/curl -fsS --max-time 20 -H "Authorization: Bearer $NTFY_TOKEN" \
      -H "Priority: urgent" -d poweroff "${config.nixos.system.killswitch.url}/$KILLSWITCH_TOPIC" \
      || echo "killswitch: ntfy failed" >&2
    ${lib.optionalString cfg.killswitchLan.enable ''
      # No host key check: a fake host cannot reuse the key login, at worst it stays on.
      for host in ${lib.escapeShellArgs cfg.killswitchLan.hosts}; do
        ${pkgs.coreutils}/bin/timeout 15 ${pkgs.openssh}/bin/ssh -i ${
          config.sops.secrets."killswitch/ssh-key".path
        } \
          -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
          "killswitch@$host" poweroff || echo "killswitch: $host not reached" >&2 &
      done
      wait
    ''}
    : > /run/killswitch/poweroff
  '';

  weishaupt_modbus = pkgs.buildHomeAssistantComponent {
    owner = "OStrama";
    domain = "weishaupt_modbus";
    version = "unstable";
    src = weishaupt-modbus;

    postPatch = ''
      find . -type f -name '*.py' -exec sed -i \
        's/from config\.custom_components\.weishaupt_modbus\./from ./g' {} +
    '';

    dependencies =
      (with haPython; [
        aiofiles
        beautifulsoup4
        pymodbus
        matplotlib
        httpx
        pygal
        scipy
      ])
      ++ [ weishaupt-webif-api ];
  };
in

{
  options.nixos = {
    server.management.homeassistant = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Home Assistant.";
      };

      killswitch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Provide script.killswitch, which publishes poweroff to the killswitch ntfy topic (secret killswitch/ha-env with NTFY_TOKEN and KILLSWITCH_TOPIC).";
      };

      killswitchButtons = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "event.killswitch_button" ];
        description = "Event entities of buttons (e.g. Matter over Thread) that run script.killswitch on the first press, without confirmation.";
      };

      killswitchLan = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "script.killswitch also powers off the hosts in the LAN over ssh, for the case without internet (secret killswitch/ssh-key, counterpart nixos.system.killswitch.lan on the hosts).";
        };

        hosts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "nixos-convertible.fritz.box"
            "nixos-desktop.fritz.box"
            "nixos-framework.fritz.box"
          ];
          description = "Hosts powered off over ssh (names of the FRITZ!Box through Pi-hole). Hosts away from home time out after 15 seconds.";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.server.management.homeassistant.enable {
    assertions = [
      {
        assertion = cfg.killswitchButtons == [ ] || cfg.killswitch;
        message = "nixos.server.management.homeassistant.killswitchButtons needs homeassistant.killswitch.";
      }
      {
        assertion = !cfg.killswitchLan.enable || cfg.killswitch;
        message = "nixos.server.management.homeassistant.killswitchLan needs homeassistant.killswitch.";
      }
    ];

    sops.secrets."killswitch/ssh-key" = lib.mkIf (cfg.killswitch && cfg.killswitchLan.enable) {
      owner = "hass";
      mode = "0400";
    };

    systemd.paths.killswitch-local = lib.mkIf cfg.killswitch {
      description = "Power off when Home Assistant runs the killswitch";
      wantedBy = [ "paths.target" ];
      pathConfig.PathExists = "/run/killswitch/poweroff";
    };
    systemd.services.killswitch-local = lib.mkIf cfg.killswitch {
      description = "Killswitch (power off on request of Home Assistant)";
      serviceConfig.Type = "oneshot";
      script = ''
        rm -f /run/killswitch/poweroff
        ${config.systemd.package}/bin/systemctl poweroff --ignore-inhibitors
      '';
    };
    systemd.services.home-assistant.serviceConfig.ReadWritePaths = lib.mkIf cfg.killswitch [
      "-/run/killswitch"
    ];

    sops.secrets."killswitch/ha-env" =
      lib.mkIf config.nixos.server.management.homeassistant.killswitch
        {
          owner = "hass";
          mode = "0400";
        };

    services.home-assistant = {
      enable = true;
      configDir = "${config.nixos.server.dataDir}/hass";

      config = {
        homeassistant = {
          name = "Home Assistant TMJF";
          unit_system = "metric";
          time_zone = "Europe/Berlin";
          temperature_unit = "C";

          packages = lib.optionalAttrs config.nixos.server.management.homeassistant.killswitch {
            killswitch = {
              shell_command.killswitch = "${killswitchScript}";
              script.killswitch = {
                alias = "Killswitch";
                icon = "mdi:power";
                mode = "single";
                sequence = [ { action = "shell_command.killswitch"; } ];
              };
              # An event entity changes its state (a timestamp) on every press. Changes from or to
              # unavailable or unknown, and entities that appear after a restart or reload, are no press.
              automation = lib.optional (cfg.killswitchButtons != [ ]) {
                id = "killswitch_button";
                alias = "Killswitch button";
                mode = "single";
                triggers = [
                  {
                    trigger = "state";
                    entity_id = cfg.killswitchButtons;
                    not_to = [
                      "unavailable"
                      "unknown"
                    ];
                  }
                ];
                conditions = [
                  {
                    condition = "template";
                    value_template = "{{ trigger.from_state is not none and trigger.from_state.state != 'unavailable' }}";
                  }
                ];
                actions = [ { action = "script.killswitch"; } ];
              };
            };
          };
        };

        default_config = { };

        lovelace = {
          dashboards = { };
        };

        "automation" = "!include automations.yaml";
        "scene" = "!include scenes.yaml";
        "script" = "!include scripts.yaml";

      };

      extraComponents = [
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        "isal"

        "androidtv_remote"
        "co2signal"
        "denon"
        "denonavr"
        "esphome"
        "forecast_solar"
        "fritzbox"
        "fritzbox_callmonitor"
        "frontier_silicon"
        "goodwe"
        "harmony"
        "homeassistant_connect_zbt2"
        "matter"
        "panasonic_bluray"
        "panasonic_viera"
        "prometheus"
        "sony_projector"
        "tankerkoenig"
        "otbr"
        "thread"
      ];

      customComponents = [ weishaupt_modbus ];

      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        tankerkoenig-card
      ];
    };

    systemd.tmpfiles.rules = [
      "z ${config.nixos.server.dataDir}/hass/www/local/weishaupt_modbus_powermap.svg 0644 hass hass -"
    ]
    # Step 3 of the killswitch script: Home Assistant may not power off, it only creates a file.
    ++ lib.optional cfg.killswitch "d /run/killswitch 0770 root hass -";

    services.matterjs-server = {
      enable = true;
      openFirewall = false;
      extraArgs = [ "--ble-proxy" ];
    };

    systemd.services.matterjs-server = {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "matter-server";
        Group = "matter-server";
      };
      unitConfig.RequiresMountsFor = "/var/lib/matterjs-server";
    };

    systemd.services.home-assistant = {
      after = [ "matterjs-server.service" ];
      wants = [ "matterjs-server.service" ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.avahi = {
      enable = true;
      settings.publish = {
        disable-publishing = false;
        disable-user-service-publishing = false;
        publish-addresses = true;
      };
    };

    services.nginx = {
      virtualHosts = {
        "homeassistant.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          extraConfig = ''
            proxy_buffering off;
            proxy_request_buffering off;
            client_max_body_size 100M;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:8123";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
