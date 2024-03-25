{ lib, pkgs, ... }:

{
  services.xserver.displayManager = {
    defaultSession = pkgs.lib.mkDefault "plasma";
  };
}
