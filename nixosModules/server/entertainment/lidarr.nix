{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.entertainment.lidarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Lidarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.lidarr.enable {
    services.lidarr = {
      enable = true;
      openFirewall = false;
      user = "lidarr";
      group = "lidarr";
      settings = {
        server = {
          bindaddress = "127.0.0.1";
          port = 8686;
        };

        update = {
          mechanism = "external";
          automatically = false;
        };

        log = {
          analyticsEnabled = false;
        };
      };
      dataDir = "${config.nixos.server.dataDir}/lidarr";
    };

    systemd.services.lidarr.serviceConfig.UMask = "0007";

    services.nginx = {
      virtualHosts = {
        "lidarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8686";
          };
        };
      };
    };
  };
}
