{ config, lib, pkgs, ... }:

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

    # AACS Keys for VLC BlueRay Discs
    systemd.user.services.keydb = {
      Unit = {
        Description = "Download KEYDB.cfg";
        ConditionPathExists = "!%h/.config/aacs/KEYDB.cfg";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p %h/.config/aacs && ${pkgs.curl}/bin/curl -L --progress-bar \"http://fvonline-db.bplaced.net/fv_download.php?lang=deu\" -o /tmp/keydb.zip && ${pkgs.unzip}/bin/unzip -p /tmp/keydb.zip keydb.cfg > %h/.config/aacs/KEYDB.cfg'";
      };
    };

    systemd.user.timers.keydb = {
      Timer.OnCalendar = "weekly";
      Install.WantedBy = [ "timers.target" ];
    };
  };
}