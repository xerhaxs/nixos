{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.system.killswitch;

  # Forced command of the key: "poweroff" powers off, "test" only answers, everything else is refused.
  lanCommand = pkgs.writeShellScript "killswitch-lan" ''
    case "''${SSH_ORIGINAL_COMMAND:-}" in
      poweroff) exec ${config.systemd.package}/bin/systemctl poweroff --ignore-inhibitors ;;
      test) echo "killswitch ok on $(${pkgs.coreutils}/bin/cat /proc/sys/kernel/hostname)" ;;
      *) echo "usage: poweroff | test" >&2; exit 1 ;;
    esac
  '';
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

      lan = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Fallback without internet: NixOS-Server1 may power this host off over ssh from the LAN (user killswitch, one key, forced command).";
        };

        publicKey = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "ssh-ed25519 AAAA... killswitch@NixOS-Server1";
          description = "Public key of NixOS-Server1 for the fallback (private key in the secret killswitch/ssh-key of NixOS-Server1).";
        };

        network = lib.mkOption {
          type = lib.types.str;
          default = "10.75.0.0/24";
          description = "Network the key is accepted from.";
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.lan.enable {
      assertions = [
        {
          assertion = cfg.lan.publicKey != "";
          message = "nixos.system.killswitch.lan.enable needs nixos.system.killswitch.lan.publicKey.";
        }
        {
          assertion = config.services.openssh.enable;
          message = "nixos.system.killswitch.lan.enable needs sshd (nixos.system.ssh.enable).";
        }
      ];

      users.groups.killswitch = { };
      users.users.killswitch = {
        isSystemUser = true;
        group = "killswitch";
        # sshd runs the forced command through the login shell.
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = [
          ''restrict,from="${cfg.lan.network}",command="${lanCommand}" ${cfg.lan.publicKey}''
        ];
      };

      services.openssh.settings.AllowUsers = [ "killswitch" ];

      # Only powering off, also with other sessions and inhibitors (an open Plasma session).
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "killswitch" &&
              (action.id == "org.freedesktop.login1.power-off" ||
               action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
               action.id == "org.freedesktop.login1.power-off-ignore-inhibit")) {
            return polkit.Result.YES;
          }
        });
      '';
    })

    (lib.mkIf cfg.enable {
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
    })
  ];
}
