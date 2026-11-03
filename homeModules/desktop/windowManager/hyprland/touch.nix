{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.touch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable touchscreen support for Hyprland (gestures, on-screen keyboard, auto rotation).";
      };
    };
  };

  # Without Hyprland the services would fall back to graphical-session.target and run in Plasma.
  config =
    lib.mkIf
      (
        config.homeManager.desktop.windowManager.hyprland.touch.enable
        && config.homeManager.desktop.windowManager.hyprland.hyprland.enable
      )
      {
        wayland.windowManager.hyprland = {
          plugins = with pkgs; [
            hyprgrass
          ];

          extraLuaFiles.touch = {
            content = ./config/touch.lua;
            autoLoad = true;
          };
        };

        home.packages = with pkgs; [
          iio-hyprland
          wvkbd
        ];

        systemd.user.services = {
          wvkbd = {
            Unit = {
              Description = "On-screen keyboard (toggle with SIGRTMIN)";
              PartOf = [ config.wayland.systemd.target ];
              After = [ config.wayland.systemd.target ];
            };
            Service = {
              ExecStart = "${pkgs.wvkbd}/bin/wvkbd-mobintl --hidden -L 300";
              Restart = "on-failure";
            };
            Install.WantedBy = [ config.wayland.systemd.target ];
          };

          iio-hyprland = {
            Unit = {
              Description = "Rotate screen and touch input by the accelerometer";
              PartOf = [ config.wayland.systemd.target ];
              After = [ config.wayland.systemd.target ];
            };
            Service = {
              ExecStart = "${pkgs.iio-hyprland}/bin/iio-hyprland";
              Restart = "on-failure";
            };
            Install.WantedBy = [ config.wayland.systemd.target ];
          };
        };
      };
}
