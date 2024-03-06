{ config, pkgs, ... }:

{
  boot.kernelModules = [ "wl" ];
}