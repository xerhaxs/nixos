{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.entertainment.sonarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sonarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = false;
      user = "sonarr";
      group = "sonarr";
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
      dataDir = "${config.nixos.server.dataDir}/sonarr";
    };

    systemd.services.sonarr.serviceConfig.UMask = lib.mkForce "0007";

    services.nginx = {
      virtualHosts = {
        "sonarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:8989";
          };
        };
      };
    };
  };
}
