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
        "nzbhydra.${config.nixos.server.network.nginx.domain}"
        "radarr.${config.nixos.server.network.nginx.domain}"
        "readarr.${config.nixos.server.network.nginx.domain}"
        "sabnzbd.${config.nixos.server.network.nginx.domain}"
        "sonarr.${config.nixos.server.network.nginx.domain}"
        "lidarr.${config.nixos.server.network.nginx.domain}"
      ];
    };
  };
}