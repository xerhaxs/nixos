{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.editing.compiler = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Media compiler tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.compiler.enable {
    home.packages = with pkgs; [
      gst_all_1.gst-libav
      #handbrake
      #makemkv
    ];

    systemd.user.services.keydb = {
      Unit.Description = "Download KEYDB.cfg";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.writeShellScript "keydb-update" ''
          set -eu
          tmp="$(mktemp -d)"
          trap 'rm -rf "$tmp"' EXIT
          ${pkgs.curl}/bin/curl -fsSL --proto =https --proto-redir =https --tlsv1.2 -o "$tmp/keydb.zip" "https://fvonline-db.bplaced.net/fv_download.php?lang=deu"
          ${pkgs.unzip}/bin/unzip -p "$tmp/keydb.zip" keydb.cfg > "$tmp/KEYDB.cfg"
          [ -s "$tmp/KEYDB.cfg" ]
          mkdir -p "$HOME/.config/aacs"
          mv "$tmp/KEYDB.cfg" "$HOME/.config/aacs/KEYDB.cfg"
        ''}";
      };
    };

    systemd.user.timers.keydb = {
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
