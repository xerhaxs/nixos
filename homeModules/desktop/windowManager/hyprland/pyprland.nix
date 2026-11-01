{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.pyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable pyprland scratchpads (dropdown terminal, volume mixer) and zoom.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.pyprland.enable {
    home.packages = with pkgs; [
      pyprland
    ];

    xdg.configFile."hypr/pyprland.toml".source = (pkgs.formats.toml { }).generate "pyprland.toml" {
      pyprland.plugins = [
        "scratchpads"
        "magnify"
      ];

      scratchpads = {
        term = {
          animation = "fromTop";
          command = "kitty --class kitty-dropdown";
          class = "kitty-dropdown";
          size = "75% 60%";
          max_size = "1920px 100%";
        };

        volume = {
          animation = "fromRight";
          command = "pavucontrol";
          class = "org.pulseaudio.pavucontrol";
          size = "40% 70%";
          unfocus = "hide";
          lazy = true;
        };
      };
    };

    systemd.user.services.pyprland = {
      Unit = {
        Description = "pyprland daemon";
        PartOf = [ config.wayland.systemd.target ];
        After = [ config.wayland.systemd.target ];
      };
      Service = {
        ExecStart = "${pkgs.pyprland}/bin/pypr";
        Restart = "on-failure";
      };
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
