{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-VMServer";
  };

  nixos.system.networking.lan.staticRouting = false;
}
