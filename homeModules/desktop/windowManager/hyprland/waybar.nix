{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland.waybar = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable waybar.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.hyprland.waybar.enable {
    programs.waybar = {
      enable = true;
      catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
      #settings = [];
    };
  };
}
