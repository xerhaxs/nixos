{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    windowManager.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable hyprland windowManager.";
      };
    };
  };

  config = mkIf config.nixos.windowManager.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
