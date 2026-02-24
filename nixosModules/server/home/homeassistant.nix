{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.home.homeassistant = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Home Assistant.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.homeassistant.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = false;
      configDir = "/pool01/applications/hass";
      #configDir = "/var/lib/hass";

      config = {
        default_config = { };
        http = {
          server_port = 8123;
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };

        homeassistant = {
          name = "Home";
          unit_system = "metric";
          time_zone = "Europe/Berlin";
          temperature_unit = "C";
          #longitude =
          #latitude =
        };
        lovelace.mode = "storage"; # ui managed
        #lovelace.mode = "yaml";
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

      #defaultIntegrations = [
      #  "application_credentials"
      #  "backup"
      #  "frontend"
      #  "hardware"
      #  "logger"
      #  "network"
      #  "system_health"
      #  "automation"
      #  "person"
      #  "scene"
      #  "script"
      #  "tag"
      #  "zone"
      #  "counter"
      #  "input_boolean"
      #  "input_button"
      #  "input_datetime"
      #  "input_number"
      #  "input_select"
      #  "input_text"
      #  "schedule"
      #  "timer"
      #];

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
        "denon"
        "denonavr"
        "esphome"
        "forecast_solar"
        "fritzbox"
        "fritzbox_callmonitor"
        "goodwe"
        "harmony"
        "panasonic_bluray"
        "sony_projector" 

        #"hassio"
      ];
    };

    services.nginx = {
      virtualHosts = {
        "homeassistant.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          extraConfig = ''
            proxy_buffering off;
          '';
          locations."/" = {
            proxyPass = "http://localhost:8123";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
