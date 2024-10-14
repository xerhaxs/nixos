{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server2";

    interfaces = {  
      enp0s18 = {
        ipv4.addresses = [ {
          address = "10.75.0.22";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "2001:16b8:a436:8300:be24:11ff:fe84:5084";
          prefixLength = 64;
        } ];
      };
    };

    nat.enable = true;

    defaultGateway6 = "fe80::1";

    useDHCP = lib.mkForce false;

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "flolserver.${config.nixos.server.network.nginx.domain}"
        "creativeserver.${config.nixos.server.network.nginx.domain}"
        "pvpserver.${config.nixos.server.network.nginx.domain}"
        "testserver.${config.nixos.server.network.nginx.domain}"
        "silverageserver.${config.nixos.server.network.nginx.domain}"
        "bluemap.${config.nixos.server.network.nginx.domain}"
        "map.${config.nixos.server.network.nginx.domain}"
      ];
    };
  };
}