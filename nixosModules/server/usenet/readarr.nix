{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.usenet.readarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Readarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.readarr.enable {
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

    services.nginx = {
      virtualHosts = {
        "readarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8787";
          };
        };
      };
    };
  };
}
