{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.gitea = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Gitea.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.gitea.enable {
    environment.systemPackages = with pkgs; [
      gitea
    ];

    # setup admin account: "gitea admin user change-password -u <username> -p <password>"

    services.gitea = {
      enable = true;
      stateDir = "/var/lib/gitea";
      useWizard = false; # should may be changed
      settings = {
        session.COOKIE_SECURE = true;
        server = {
          PROTOCOL = "http";
          HTTP_PORT = 3005;
          HTTP_ADDR = "localhost";
          DOMAIN = "gitea.${config.nixos.server.network.nginx.domain}";
        };
      };

      dump = {
        enable = true;
        type = "zip";
        interval = "hourly";
      };

      database = {
        type = "sqlite3";
      };
    };

    services.nginx = {
      virtualHosts = {
        "gitea.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3005";
          };
        };
      };
    };

    services.ddclient.domains = [
      "gitea.${config.nixos.server.network.nginx.domain}"
    ];
  }; 
}
