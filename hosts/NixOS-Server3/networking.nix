{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server3";

    interfaces = {  
      ens18 = {
        ipv4.addresses = [ {
          address = "10.75.0.23";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "2001:16b8:a400:cc00:be24:11ff:fef2:1e0f";
          prefixLength = 64;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "nzbget.m4rx.cc"
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