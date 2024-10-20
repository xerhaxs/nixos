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
        ipv6.addresses = [ {
          address = "2001:16b8:a400:cc00:80e6:a492:a930:d14c";
          prefixLength = 64;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

    defaultGateway = "10.75.0.1";
  };
}