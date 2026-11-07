{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.killswitch;
in

{
  options.nixos = {
    system.killswitch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Power off immediately when the message poweroff is published to the killswitch ntfy topic.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://push.${config.nixos.site.domain}";
        defaultText = lib.literalExpression ''"https://push.''${config.nixos.site.domain}"'';
        description = "URL of the ntfy server.";
      };

      delay = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        example = 60;
        description = "Seconds to wait before powering off (e.g. on the host that sends the signal).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # NTFY_TOKEN=tk_... (read access to the topic), KILLSWITCH_TOPIC=<secret topic name>
    sops.secrets."killswitch/env".restartUnits = [ "killswitch.service" ];

    systemd.services.killswitch = {
      description = "Killswitch (power off on ntfy message)";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = [
        pkgs.ntfy-sh
        pkgs.coreutils
        config.systemd.package
      ];
      script = ''
        exec ntfy subscribe --token "$NTFY_TOKEN" "${cfg.url}/$KILLSWITCH_TOPIC" \
          'if [ "$NTFY_MESSAGE" = "poweroff" ]; then sleep ${toString cfg.delay}; systemctl poweroff --ignore-inhibitors; fi'
      '';
      serviceConfig = {
        EnvironmentFile = config.sops.secrets."killswitch/env".path;
        Restart = "always";
        RestartSec = 15;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
      };
    };
  };
}
