{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.entertainment.radarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.entertainment.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = false;
      user = "radarr";
      group = "radarr";
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
      dataDir = "${config.nixos.server.dataDir}/radarr";
    };

    # PrivateUsers (nixpkgs default) drops the supplementary group share, the media folders are only
    # accessible through it (imports failed with "path does not exist or is not accessible").
    systemd.services.radarr.serviceConfig = {
      UMask = lib.mkForce "0007";
      PrivateUsers = lib.mkForce false;
    };

    services.nginx = {
      virtualHosts = {
        "radarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:7878";
          };
        };
      };
    };
  };
}
