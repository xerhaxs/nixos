{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server3";

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
        "lidarr.m4rx.cc"
        "nzbget.m4rx.cc"
        "nzbhydra.m4rx.cc"
        "radarr.m4rx.cc"
        "sonarr.m4rx.cc"
        "readarr.m4rx.cc"
      ];
    };
  };
}