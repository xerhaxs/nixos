{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.network.fail2ban = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fail2ban for the web services (ssh is protected by sshguard).";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.fail2ban.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        maxtime = "168h";
        overalljails = true;
      };
      ignoreIP = [
        "127.0.0.0/8"
        "::1"
      ];
      # Keeps the ban history for the increment (default 1d would forget repeat offenders).
      daemonSettings.Definition.dbpurgeage = "30d";

      jails = {
        sshd.settings.enabled = false;

        nginx-botsearch.settings = lib.mkIf config.services.nginx.enable {
          enabled = true;
          filter = "nginx-botsearch";
          logpath = "/var/log/nginx/access.log";
          backend = "auto";
        };

        nginx-bad-request.settings = lib.mkIf config.services.nginx.enable {
          enabled = true;
          filter = "nginx-bad-request";
          logpath = "/var/log/nginx/access.log";
          backend = "auto";
        };
      };
    };

    # Bans survive a reboot, fail2ban restores them from its database.
    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [ "/var/lib/fail2ban" ];
    };
  };
}
