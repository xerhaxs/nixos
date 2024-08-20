{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Desktop";

    interfaces = {  
      enp5s0 = {
        ipv4.addresses = [ {
          address = "10.75.0.80";
          prefixLength = 24;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

    defaultGateway = "10.75.0.1";
  };
}