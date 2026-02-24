{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.usenet.sonarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sonarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = false;
      #environmentFiles = [];
      settings = {
        server = {
          urlbase = "localhost";
          port = 8989;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };

        log = {
          analyticsEnabled = false;
        };
      };
      #dataDir = "/var/lib/sonarr";
      dataDir = "/pool01/applications/sonarr";
    };

    services.nginx = {
      virtualHosts = {
        "sonarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8989";
          };
        };
      };
    };
  };
}
