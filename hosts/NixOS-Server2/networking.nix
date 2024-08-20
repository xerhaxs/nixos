{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server2";

    #interfaces = {  
    #  enp5s0 = {
    #    ipv4.addresses = [ {
    #      address = "10.75.0.115";
    #      prefixLength = 24;
    #    } ];
    #  };
    #};

    useDHCP = lib.mkForce true;

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "flolserver.m4rx.cc"
        "pufferpanel.m4rx.cc"
        "map.m4rx.cc"
        "analytics.m4rx.cc"
      ];
    };
  };
}