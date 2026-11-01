{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-VMDesktop";
  };

  nixos.system.networking.lan.staticRouting = false;
}
