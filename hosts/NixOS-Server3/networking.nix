{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server3";

    interfaces = {  
      enp0s18 = {
        ipv4.addresses = [ {
          address = "10.75.0.23";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "fe80::3128:c782:a68c:7e25";
          prefixLength = 64;
        } ];
      };
    };

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "nzbhydra.m4rx.cc"
        "radarr.m4rx.cc"
        "readarr.m4rx.cc"
        "sabnzbd.m4rx.cc"
        "sonarr.m4rx.cc"
        "lidarr.m4rx.cc"
      ];
    };
  };
}