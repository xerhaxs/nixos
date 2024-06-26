{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server2";

    interfaces = {  
      enp5s0 = {
        ipv4.addresses = [ {
          address = "10.75.0.115";
          prefixLength = 24;
        } ];
      };
    };

    useDHCP = lib.mkForce false;
  };
}