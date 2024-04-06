{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable hyprland modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.windowManager.hyprland.enable && osConfig.nixos.desktop.windowManager.hyprland.enable) {
    imports = [
      ./dunst.nix
      ./hyprland.nix
      ./waybar.nix
      ./wofi.nix
    ];
  };
}