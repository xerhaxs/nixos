{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.usenet.radarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = false;
      user = "radarr";
      group = "radarr";
      #environmentFiles = [];
      settings = {
        server = {
          urlbase = "localhost";
          port = 7878;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };

        log = {
          analyticsEnabled = false;
        };
      };
      #dataDir = "/var/lib/radarr/.config/radarr";
      dataDir = "/pool01/applications/radarr";
    };

    services.nginx = {
      virtualHosts = {
        "radarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:7878";
          };
        };
      };
    };
  };
}
