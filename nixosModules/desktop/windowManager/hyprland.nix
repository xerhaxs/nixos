{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.windowManager.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hyprland windowManager.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.windowManager.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
