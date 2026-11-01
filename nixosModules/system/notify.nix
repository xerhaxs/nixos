{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.notify;
  hostName = config.networking.hostName;

  notifyAlert = pkgs.writeShellScriptBin "notify-alert" ''
    subject="[${hostName}] $1"
    body="$(cat)"
    ${lib.optionalString cfg.mail.enable ''
      printf 'To: %s\nFrom: %s\nSubject: %s\n\n%s\n' "${cfg.mail.to}" "${cfg.mail.from}" "$subject" "$body" \
        | ${pkgs.msmtp}/bin/msmtp --read-recipients || echo "notify-alert: mail failed" >&2
    ''}
    ${lib.optionalString cfg.ntfy.enable ''
      set -a; . ${config.sops.secrets."notify/ntfy-env".path}; set +a
      printf '%s' "$body" | ${pkgs.curl}/bin/curl -fsS --max-time 30 \
        -H "Authorization: Bearer $NTFY_TOKEN" -H "Title: $subject" -H "Priority: high" -H "Tags: warning" \
        --data-binary @- "${cfg.ntfy.url}/$ALERT_TOPIC" > /dev/null || echo "notify-alert: ntfy failed" >&2
    ''}
  '';

  failureDropIn = pkgs.writeTextDir "etc/systemd/system/service.d/10-notify-failure.conf" ''
    [Unit]
    OnFailure=notify-failure@%N.service
  '';

  failureDropInSelf = pkgs.writeTextDir "etc/systemd/system/notify-failure@.service.d/10-no-notify.conf" ''
    [Unit]
    OnFailure=
  '';
in

{
  options.nixos = {
    system.notify = {
      mail = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Send system alerts by mail (msmtp as sendmail, secret notify/mail-password).";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "mail.${config.nixos.site.mailDomain}";
          defaultText = lib.literalExpression ''"mail.''${config.nixos.site.mailDomain}"'';
          description = "SMTP server (submission with implicit TLS).";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 465;
          description = "SMTP port.";
        };

        from = lib.mkOption {
          type = lib.types.str;
          default = "alerts@${config.nixos.site.mailDomain}";
          defaultText = lib.literalExpression ''"alerts@''${config.nixos.site.mailDomain}"'';
          description = "Sender address and SMTP login.";
        };

        to = lib.mkOption {
          type = lib.types.str;
          default = config.nixos.site.alertEmail;
          defaultText = lib.literalExpression "config.nixos.site.alertEmail";
          description = "Recipient of the alerts.";
        };
      };

      ntfy = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Send system alerts to ntfy (secret notify/ntfy-env with NTFY_TOKEN and ALERT_TOPIC).";
        };

        url = lib.mkOption {
          type = lib.types.str;
          default = "https://push.${config.nixos.site.domain}";
          defaultText = lib.literalExpression ''"https://push.''${config.nixos.site.domain}"'';
          description = "URL of the ntfy server.";
        };
      };

      onFailure = lib.mkOption {
        type = lib.types.bool;
        default = cfg.mail.enable || cfg.ntfy.enable;
        defaultText = lib.literalExpression "mail.enable || ntfy.enable";
        description = "Notify when any systemd service fails.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.mail.enable || cfg.ntfy.enable) {
      environment.systemPackages = [ notifyAlert ];
    })

    (lib.mkIf cfg.mail.enable {
      sops.secrets."notify/mail-password" = { };

      programs.msmtp = {
        enable = true;
        setSendmail = true;
        defaults = {
          aliases = "/etc/aliases";
          tls = true;
          tls_starttls = false;
          auth = true;
        };
        accounts.default = {
          host = cfg.mail.host;
          port = cfg.mail.port;
          from = cfg.mail.from;
          user = cfg.mail.from;
          passwordeval = "cat ${config.sops.secrets."notify/mail-password".path}";
        };
      };

      environment.etc."aliases".text = ''
        root: ${cfg.mail.to}
        default: ${cfg.mail.to}
      '';

      services.smartd.notifications.mail = {
        enable = true;
        sender = cfg.mail.from;
        recipient = cfg.mail.to;
        mailer = "${pkgs.msmtp}/bin/sendmail";
      };

      services.zfs.zed.settings = lib.mkIf config.boot.zfs.enabled {
        ZED_EMAIL_ADDR = [ cfg.mail.to ];
        ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
        ZED_EMAIL_OPTS = "@ADDRESS@";
        ZED_NOTIFY_INTERVAL_SECS = 3600;
        ZED_NOTIFY_VERBOSE = true;
      };
    })

    (lib.mkIf cfg.ntfy.enable {
      sops.secrets."notify/ntfy-env" = { };
    })

    (lib.mkIf cfg.onFailure {
      systemd.packages = [
        failureDropIn
        failureDropInSelf
      ];

      systemd.services."notify-failure@" = {
        description = "Notify about the failure of %i";
        serviceConfig = config.nixos.system.hardening.unitHardening // {
          Type = "oneshot";
          ProtectSystem = "strict";
        };
        scriptArgs = "%i";
        script = ''
          unit="$1"
          {
            ${config.systemd.package}/bin/systemctl status --full --no-pager "$unit" || true
            echo
            ${config.systemd.package}/bin/journalctl -u "$unit" -n 50 --no-pager || true
          } | ${notifyAlert}/bin/notify-alert "$unit failed"
        '';
      };
    })
  ];
}
