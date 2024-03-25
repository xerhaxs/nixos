{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    defaultSession = lib.mkDefault "plasmawayland";
  };
}
