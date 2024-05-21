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
      enable = true;
      catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
      settings = {};
    };
  };
}
