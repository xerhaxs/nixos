{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server1";

    interfaces = {  
      ens18 = {
        ipv4.addresses = [ {
          address = "10.75.0.21";
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "fe80::be24:11ff:fef3:96ff";
          prefixLength = 64;
        } ];
      };
    };

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "freshrss.${config.nixos.server.network.nginx.domain}"
        "glance.${config.nixos.server.network.nginx.domain}"
        "invidious.${config.nixos.server.network.nginx.domain}"
        #"jellyfin.${config.nixos.server.network.nginx.domain}"
        #"kiwix.${config.nixos.server.network.nginx.domain}"
        "libreddit.${config.nixos.server.network.nginx.domain}"
        "ollama.${config.nixos.server.network.nginx.domain}"
        "radicale.${config.nixos.server.network.nginx.domain}"
        "nitter.${config.nixos.server.network.nginx.domain}"
        "pihole.${config.nixos.server.network.nginx.domain}"
        "rss.${config.nixos.server.network.nginx.domain}"
        "search.${config.nixos.server.network.nginx.domain}"
        "searx.${config.nixos.server.network.nginx.domain}"
        "searxng.${config.nixos.server.network.nginx.domain}"
        #"syncthing.${config.nixos.server.network.nginx.domain}"
      ];
    };
  };
}