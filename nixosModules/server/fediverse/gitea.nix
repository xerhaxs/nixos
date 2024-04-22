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
          DOMAIN = "gitea.bitsync.icu";
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
  }; 
}
