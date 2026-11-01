{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "NixOS-VMServerGaming";

  nixos.system.networking = {
    enable = true;
    lan.staticRouting = false;
  };
}
