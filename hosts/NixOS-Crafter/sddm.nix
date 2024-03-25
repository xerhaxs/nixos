{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.wayland.enable = pkgs.lib.mkDefault false;
    defaultSession = pkgs.lib.mkDefault "plasma-x11";
  };
}
