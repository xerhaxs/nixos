{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    desktop.windowManager.hyprland.rofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable rofi.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;

      plugins = with pkgs; [
        rofi-calc
        rofi-bluetooth
        rofi-screenshot
        rofi-power-menu
      ];

      settings = {
        terminal = "kitty";
        location = 0;
        modi = "drun,run,window,calc";
        show-icons = true;
        drun-display-format = "{name}";
        display-drun = "Apps";
        display-run = "Run";
        display-window = "Windows";
        display-calc = "Calc";
      };
    };
  };
}
