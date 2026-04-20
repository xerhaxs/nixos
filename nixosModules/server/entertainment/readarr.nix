{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.entertainment.readarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Readarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.readarr.enable {
    services.readarr = {
      enable = true;
      openFirewall = false;
      user = "readarr";
      group = "readarr";
      #environmentFiles = [];
      settings = {
        server = {
          urlbase = "localhost";
          port = 8787;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };

        log = {
          analyticsEnabled = false;
        };
      };
      #dataDir = "/var/lib/readarr/";
      dataDir = "/pool01/applications/readarr/";
    };

    systemd.services.readarr.serviceConfig.UMask = "0007";

    services.nginx = {
      virtualHosts = {
        "readarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:8787";
          };
        };
      };
    };
  };
}
