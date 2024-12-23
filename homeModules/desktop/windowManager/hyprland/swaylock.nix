{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland.swaylock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable swaylock.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.swaylock.enable {  
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
      };
    };

    catppuccin.swaylock.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
