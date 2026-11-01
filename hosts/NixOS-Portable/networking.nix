{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-Portable";
  };

  nixos.system.networking = {
    enable = true;
    wifi.enable = true;
    lan.staticRouting = false;
    privateDns = true;
    macRandomization = {
      wifi = true;
      ethernet = true;
    };
  };
}
