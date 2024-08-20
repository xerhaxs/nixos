{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server";

    interfaces = {  
      ens18 = {
        ipv4.addresses = [ {
          address = "10.75.0.21";
          prefixLength = 24;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

    hosts = {
      "127.0.0.1" = lib.mkDefault [
        "ytdl.m4rx.cc"
        "freshrss.m4rx.cc"
        "rss.m4rx.cc"
        "invidious.m4rx.cc"
        "libreddit.m4rx.cc"
        "nextcloud.m4rx.cc"
        "nitter.m4rx.cc"
        "pihole.m4rx.cc"
        "searx.m4rx.cc"
        "searxng.m4rx.cc"
        "search.m4rx.cc"
        "uptime.m4rx.cc"
        "kuma.m4rx.cc"
        "jellyfin.m4rx.cc"
        "collabora.m4rx.cc"
        "syncthing.m4rx.cc"
        "kiwix.m4rx.cc"
      ];
    };
  };
}