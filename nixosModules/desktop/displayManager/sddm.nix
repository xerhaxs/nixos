{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.displayManager.sddm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable SDDM display manager.";
      };
    };
  };

  config = mkIf config.nixos.desktop.displayManager.sddm.enable {
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        enableHidpi = false;
      };
      defaultSession = "hyprland";
    };
  };
}
