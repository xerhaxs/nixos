{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server2";

    interfaces = {  
      enp0s18 = {
        ipv4.addresses = [ {
          address = "10.75.0.22";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "fe80::5702:f205:97a3:516f";
          prefixLength = 64;
        } ];
      };
    };
  };

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.22";
  };
}