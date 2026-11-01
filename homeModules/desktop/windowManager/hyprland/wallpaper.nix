{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  cfg = config.homeManager.desktop.windowManager.hyprland.wallpaper;

  randomWallpaper = pkgs.writeShellApplication {
    name = "wallpaper-random";
    runtimeInputs = with pkgs; [
      findutils
      coreutils
      awww
    ];
    text = ''
      image="$(find -L ${lib.escapeShellArg cfg.directory} -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) | shuf -n 1)"
      [ -n "$image" ] || exit 0
      awww img --transition-type any --transition-fps 60 --transition-duration 2 "$image"
    '';
  };
in

{
  options.homeManager = {
    desktop.windowManager.hyprland.wallpaper = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable awww (swww) wallpapers with waypaper and a random slideshow.";
      };

      directory = lib.mkOption {
        type = lib.types.str;
        default = "${config.xdg.userDirs.pictures}/Desktopbilder";
        defaultText = lib.literalExpression ''"''${config.xdg.userDirs.pictures}/Desktopbilder"'';
        description = "Directory with the wallpapers of the slideshow (searched recursively).";
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = "10min";
        description = "Interval of the slideshow (systemd time span).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waypaper
    ];

    services.awww.enable = true;

    home.activation.waypaperConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      CONFIG="$HOME/.config/waypaper/config.ini"
      mkdir -p "$(dirname "$CONFIG")"
      ${pkgs.crudini}/bin/crudini --set "$CONFIG" Settings folder ${lib.escapeShellArg cfg.directory}
      ${pkgs.crudini}/bin/crudini --set "$CONFIG" Settings backend awww
      ${pkgs.crudini}/bin/crudini --set "$CONFIG" Settings fill fill
      ${pkgs.crudini}/bin/crudini --set "$CONFIG" Settings subfolders True
      ${pkgs.crudini}/bin/crudini --set "$CONFIG" Settings swww_transition_type any
    '';

    systemd.user.services = {
      wallpaper-random = {
        Unit = {
          Description = "Set a random wallpaper";
          Requires = [ "awww.service" ];
          After = [ "awww.service" ];
          PartOf = [ config.wayland.systemd.target ];
        };
        Service = {
          Type = "oneshot";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
          ExecStart = lib.getExe randomWallpaper;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };

    systemd.user.timers.wallpaper-random = {
      Unit = {
        Description = "Wallpaper slideshow";
        PartOf = [ config.wayland.systemd.target ];
      };
      Timer = {
        OnUnitActiveSec = cfg.interval;
        OnActiveSec = cfg.interval;
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/waypaper"
      ];
    };
  };
}
