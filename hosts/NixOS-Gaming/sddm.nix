{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.wayland.enable = pkgs.lib.mkDefault false;
    defaultSession = pkgs.lib.mkDefault "plasma"; # plasma-bigscreen-x11 / plasma-bigscreen-x11
  };
}
