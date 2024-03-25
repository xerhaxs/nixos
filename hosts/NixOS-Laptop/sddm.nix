{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    defaultSession = lib.mkForce "plasmawayland";
  };
}
