{
  config,
  lib,
  pkgs,
  ...
}:

let
  nextcloudLog = "${config.services.nextcloud.home}/data/nextcloud.log";
in

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
        config.nixos.system.wireguard.subnet
      ];

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

        nextcloud.settings = lib.mkIf config.services.nextcloud.enable {
          enabled = true;
          filter = "nextcloud";
          logpath = nextcloudLog;
          backend = "auto";
          maxretry = 5;
        };
      };
    };

    environment.etc."fail2ban/filter.d/nextcloud.conf".text =
      lib.mkIf config.services.nextcloud.enable ''
        [Definition]
        _groupsre = (?:(?:,?\s*"\w+":(?:"[^"]+"|\w+))*)
        failregex = ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Login failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Two-factor challenge failed:
                    ^\{%(_groupsre)s,?\s*"remoteAddr":"<HOST>"%(_groupsre)s,?\s*"message":"Trusted domain error.
        datepattern = ,?\s*"time"\s*:\s*"%%Y-%%m-%%d[T ]%%H:%%M:%%S(%%z)?"
      '';
  };
}
