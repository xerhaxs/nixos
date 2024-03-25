{ config, lib, pkgs, ... }:

{
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
