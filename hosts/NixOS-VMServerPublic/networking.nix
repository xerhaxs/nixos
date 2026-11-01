{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "NixOS-VMServerPublic";

  nixos.system.networking = {
    enable = true;
    lan.staticRouting = false;
  };
}
