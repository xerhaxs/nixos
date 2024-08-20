{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server2";

    interfaces = {  
      ens18 = {
        ipv4.addresses = [ {
          address = "10.75.0.22";
          prefixLength = 24;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

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