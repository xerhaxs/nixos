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
          #mode = "yaml";
          mode = "storage";
        };
      };

      /* lovelaceConfig = "";
      lovelaceConfigWritable = false;
      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
        mini-graph-card
        mini-media-player
        mushroom
      ]; */

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
        "panasonic_bluray"
        "sony_projector"
        "homeassistant_connect_zbt2"
        "matter"
        "thread"
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
  };
}
