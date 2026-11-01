{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "NixOS-Convertible";
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
    #localIP = "10.75.0.103";
  };
}
