{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  cfg = config.homeManager.applications.sync.protonBackup;
  configDir = "${config.xdg.configHome}/rclone-proton";
  credConfig = "${config.xdg.configHome}/git-credential-keepassxc/config.json";

  # The restic passphrase from KeePassXC, it also encrypts the rclone config (no copy on disk).
  passphrase = pkgs.writeShellScript "proton-backup-passphrase" ''
    printf 'protocol=https\nhost=${cfg.keepassxcHost}\n\n' \
      | ${pkgs.git-credential-keepassxc}/bin/git-credential-keepassxc --config "${credConfig}" --unlock 3 get \
      | ${pkgs.gnused}/bin/sed -n 's/^password=//p'
  '';

  # restic calls fusermount, NixOS only has the setuid wrapper fusermount3.
  fusermount = pkgs.runCommand "fusermount-shim" { } ''
    mkdir -p $out/bin
    ln -s /run/wrappers/bin/fusermount3 $out/bin/fusermount
  '';

  protonBackup = pkgs.writeShellScriptBin "proton-backup" ''
    set -eu
    export PATH=${
      lib.makeBinPath [
        fusermount
        pkgs.coreutils
        pkgs.rclone
        pkgs.restic
      ]
    }:$PATH
    export RCLONE_CONFIG="${configDir}/rclone.conf"
    export RCLONE_PASSWORD_COMMAND="${passphrase}"
    export RESTIC_PASSWORD_COMMAND="${passphrase}"
    export RESTIC_REPOSITORY="${cfg.repository}"

    case "''${1:-mount}" in
      setup)
        # Login once, the password is only passed through the environment and not stored, the
        # config keeps the session tokens (rclone renews them) and is encrypted with the passphrase.
        tmp=$(mktemp -d -p "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}")
        trap 'rm -rf "$tmp"' EXIT
        read -rp "Proton address: " user
        read -rsp "Proton password: " pw; echo
        read -rp "Current 2FA code (empty without 2FA): " code
        RCLONE_PROTONDRIVE_PASSWORD=$(printf '%s' "$pw" | rclone obscure -)
        unset pw
        export RCLONE_PROTONDRIVE_PASSWORD RCLONE_PROTONDRIVE_2FA="$code"
        RCLONE_CONFIG="$tmp/rclone.conf" rclone config create proton protondrive username="$user" --non-interactive > /dev/null
        RCLONE_CONFIG="$tmp/rclone.conf" rclone lsd proton: > /dev/null
        unset RCLONE_PROTONDRIVE_PASSWORD RCLONE_PROTONDRIVE_2FA
        RCLONE_CONFIG="$tmp/rclone.conf" RCLONE_PASSWORD_CHANGE=1 rclone config encryption set
        install -D -m 0600 "$tmp/rclone.conf" "$RCLONE_CONFIG"
        echo "Logged in, the config is encrypted in $RCLONE_CONFIG."
        ;;
      mount)
        if [ ! -s "$RCLONE_CONFIG" ]; then
          echo "Not set up yet: proton-backup setup" >&2
          exit 1
        fi
        mkdir -p "${cfg.mountPoint}"
        echo "Read-only in ${cfg.mountPoint}/snapshots/<date>, Ctrl+C unmounts."
        exec restic mount "${cfg.mountPoint}"
        ;;
      help | -h | --help)
        echo "proton-backup setup       log in to Proton once (2FA code), stored encrypted"
        echo "proton-backup [mount]     browse all versions read-only in ${cfg.mountPoint}"
        echo "proton-backup <restic>    any restic command, e.g. snapshots, ls latest, restore"
        ;;
      *)
        exec restic "$@"
        ;;
    esac
  '';
in

{
  options.homeManager = {
    applications.sync.protonBackup = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Command proton-backup to browse and restore the restic backup of NixOS-Server1 on Proton Drive (read only, passphrase from KeePassXC).";
      };

      repository = lib.mkOption {
        type = lib.types.str;
        default = "rclone:proton:nixos-server1";
        description = "restic repository of the backup.";
      };

      keepassxcHost = lib.mkOption {
        type = lib.types.str;
        default = "restic-proton.invalid";
        description = "Host of the URL (https://<host>) of the KeePassXC entry with the restic passphrase.";
      };

      mountPoint = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/ProtonBackup";
        defaultText = lib.literalExpression ''"''${config.home.homeDirectory}/ProtonBackup"'';
        description = "Where proton-backup mount shows the snapshots.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ protonBackup ];

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".cache/restic"
        ".config/rclone-proton"
      ];
    };
  };
}
