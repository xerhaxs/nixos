{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    #./dunst.nix
    ./hyprland.nix
    ./swaylock.nix
    ./waybar.nix
    ./rofi.nix
  ];

  options.homeManager = {
    desktop.windowManager.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hyprland modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.windowManager.hyprland.enable && osConfig.nixos.desktop.windowManager.hyprland.enable) {
    homeManager.desktop.windowManager.hyprland = {
      #dunst.enable = true;
      hyprland.enable = true;
      swaylock.enable = true;
      waybar.enable = true;
      rofi.enable = true;
    };
  };
}