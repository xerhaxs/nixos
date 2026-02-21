{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {

    hostName = "NixOS-ServerPublic";

    #interfaces = {
    #  enp0s18 = {
    #    ipv4.addresses = [ {
    #      address = "10.75.0.22";
    #      prefixLength = 24;
    #    } ];
    #    ipv6.addresses = [ {
    #      address = "fe80::5702:f205:97a3:516f";
    #      prefixLength = 64;
    #    } ];
    #  };
    #};

    hosts = {
      "127.0.0.1" = [
        "flolserver.${config.nixos.server.network.nginx.domain}"
      ];
    };
  };
}
