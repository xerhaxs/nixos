{
  config,
  lib,
  pkgs,
  weishaupt-modbus,
  ...
}:

let
  haPython = pkgs.home-assistant.python3Packages;

  weishaupt-webif-api = haPython.buildPythonPackage rec {
    pname = "weishaupt-webif-api";
    version = "0.1.4";
    pyproject = true;

    src = haPython.fetchPypi {
      pname = "weishaupt_webif_api";
      inherit version;
      hash = "sha256-WIRVAH5EZNvfmQDn94iZAo5voIYXlgKPK450XdfPZkw=";
    };

    build-system = [ haPython.setuptools ];

    dependencies = with haPython; [
      httpx
      beautifulsoup4
    ];

    pythonImportsCheck = [ "weishaupt_webif_api" ];
  };

  weishaupt_modbus = pkgs.buildHomeAssistantComponent {
    owner = "OStrama";
    domain = "weishaupt_modbus";
    version = "unstable";
    src = weishaupt-modbus;
    dependencies =
      (with haPython; [
        aiofiles
        beautifulsoup4
        pymodbus
        matplotlib
        httpx
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
    };
  };

  config = lib.mkIf config.nixos.server.management.homeassistant.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = false;
      configDir = "/pool01/applications/hass";
      #configDir = "/var/lib/hass";
      #configWritable = true;

      config = {
        http = {
          server_port = 8123;
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };

        homeassistant = {
          name = "Home Assistant TMJF";
          unit_system = "metric";
          time_zone = "Europe/Berlin";
          temperature_unit = "C";
          #longitude =
          #latitude =
        };

        default_config = { };

        lovelace = {
          dashboards = { };
        };

        "automation" = "!include automations.yaml";
        "scene" = "!include scenes.yaml";
        "script" = "!include scripts.yaml";

        switch = [
          {
            platform = "sony_projector";
            host = "10.75.0.97";
            name = "SonyBeamer";
          }
        ];

        media_player = [
          {
            platform = "panasonic_bluray";
            host = "10.75.0.60";
            name = "UHD Player";
          }
        ];
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
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"

        # for home integration
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
        "thread"
      ];

      customComponents = [ weishaupt_modbus ];
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

    /*
      environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
        directories = [
          "/var/lib/hass"
        ];
      };
    */
  };
}
