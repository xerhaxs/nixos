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

    useDHCP = lib.mkForce true;

    #hosts = {
    #  "127.0.0.1" = lib.mkDefault [
    #    "flolserver.${config.nixos.server.network.nginx.domain}"
    #    "creativeserver.${config.nixos.server.network.nginx.domain}"
    ##    "pvpserver.${config.nixos.server.network.nginx.domain}"
    #    "testserver.${config.nixos.server.network.nginx.domain}"
    #    "silverageserver.${config.nixos.server.network.nginx.domain}"
    #    "bluemap.${config.nixos.server.network.nginx.domain}"
    #    "map.${config.nixos.server.network.nginx.domain}"
    #  ];
    #};
  };
}