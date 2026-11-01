{
  config,
  lib,
  pkgs,
  weishaupt-modbus,
  weishaupt-webif-api-src,
  ...
}:

let
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

  killswitchScript = pkgs.writeShellScript "killswitch-publish" ''
    set -a; . ${config.sops.secrets."killswitch/ha-env".path}; set +a
    exec ${pkgs.curl}/bin/curl -fsS --max-time 20 -H "Authorization: Bearer $NTFY_TOKEN" \
      -H "Priority: urgent" -d poweroff "${config.nixos.system.killswitch.url}/$KILLSWITCH_TOPIC"
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
    };
  };

  config = lib.mkIf config.nixos.server.management.homeassistant.enable {
    sops.secrets."killswitch/ha-env" =
      lib.mkIf config.nixos.server.management.homeassistant.killswitch
        {
          owner = "hass";
          mode = "0400";
        };

    services.home-assistant = {
      enable = true;
      configDir = "${config.nixos.server.dataDir}/hass";
      #configDir = "/var/lib/hass";
      #configWritable = true;

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

      /*
        lovelaceConfig = "";
        lovelaceConfigWritable = false;
        customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
          mini-graph-card
          mini-media-player
          mushroom
        ];
      */

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
    ];

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
      publish.enable = true;
      publish.userServices = true;
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
            proxyPass = "http://localhost:8123";
            proxyWebsockets = true;
          };
        };
      };
    };

    # environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    #   directories = [
    #     "/var/lib/hass"
    #     "/var/lib/thread"
    #     {
    #       directory = "var/lib/matterjs-server";
    #       user = "matter-server";
    #       group = "matter-server";
    #       mode = "0700";
    #     }
    #   ];
    # };
  };
}
