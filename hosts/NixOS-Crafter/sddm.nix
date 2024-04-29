{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    sddm.wayland.enable = lib.mkForce false;
    defaultSession = lib.mkForce "plasma";
  };
}
