{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server";

    #interfaces = {  
    #  enp5s0 = {
    #    ipv4.addresses = [ {
    #      address = "10.75.0.20";
    #      prefixLength = 24;
    #    } ];
    #  };
    #};

    useDHCP = lib.mkForce true;
  };
}