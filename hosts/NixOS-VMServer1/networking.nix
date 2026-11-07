{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-VMServer1";
  };

  nixos.system.networking.lan.staticRouting = false;
}
