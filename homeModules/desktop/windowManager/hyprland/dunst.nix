{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland.dunst = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable dunst.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.dunst.enable {
    services.dunst = {
      enable = false;

      settings = {
        global = {
          frame_color = "#89B4FA";
          separator_color = "frame";
        };

        urgency_low = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_normal = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
        };

        urgency_critical = {
          background = "#1E1E2E";
          foreground = "#CDD6F4";
          frame_color = "#FAB387";
        };
      };
    };
  };
}
