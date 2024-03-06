{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    defaultSession = pkgs.lib.mkDefault "plasmawayland";
  };
}
