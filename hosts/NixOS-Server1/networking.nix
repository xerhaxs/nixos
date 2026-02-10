{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server1";

    interfaces = {  
      enp0s18 = {
        ipv4.addresses = [ {
          address = "10.75.0.21";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "fe80::be24:11ff:fef3:96ff";
          prefixLength = 64;
        } ];
      };
    };
  };

  nixos.system.networking = {
    enable = true;
    localIP = "10.75.0.21";
  };
}