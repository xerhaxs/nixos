{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        enableHidpi = true;
      };
      defaultSession = "plasmawayland";
    };
  };
}
