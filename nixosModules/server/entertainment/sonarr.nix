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
          bindaddress = "127.0.0.1";
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
      dataDir = "${config.nixos.server.dataDir}/sonarr";
    };

    # PrivateUsers (nixpkgs default) drops the supplementary group share, the media folders are only
    # accessible through it (imports failed with "path does not exist or is not accessible").
    systemd.services.sonarr.serviceConfig = {
      UMask = lib.mkForce "0007";
      PrivateUsers = lib.mkForce false;
    };

    services.nginx = {
      virtualHosts = {
        "sonarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8989";
          };
        };
      };
    };
  };
}
