{ config, lib, pkgs, ... }:

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
      
      openFirewall = true;
      configDir = "/var/lib/hass";

      config = {
        default_config = {};
        http = {
          server_port = 8123;
          use_x_forwarded_for = true;
          server_host = [ "0.0.0.0" ];
          trusted_proxies = [ "127.0.0.1" ];
        };

        homeassistant = {
          name = "Home";
          unit_system = "metric";
          time_zone = "Europe/Berlin";
          temperature_unit = "C";
          #longitude =
          #latitude = 
        };
        lovelace.mode = "yaml";
      };

  #    lovelaceConfig = "";
      lovelaceConfigWritable = false;
      customLovelaceModules =  with pkgs.home-assistant-custom-lovelace-modules; [
        mini-graph-card
        mini-media-player
        mushroom
      ];

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
        "androidtv"
        "androidtv_remote"
        "default_config"
        "denon"
        "denonavr"
        "esphome"
        "fire_tv"
        "forecast_solar"
        "fritzbox"
        "fritzbox_callmonitor"
        "goodwe"
        "harmony"
        "hassio"
        "heos"
        "met"
        "panasonic_bluray"
        "radio_browser"
        "sony_projector"
        "supervisord"
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
          locations."/" = {
            proxyPass = "http://localhost:8123";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
