{ config, lib, pkgs, ... }:

{
  networking = {

    hostName = "NixOS-Server";

    interfaces = {  
      enp5s0 = {
        ipv4.addresses = [ {
          address = "10.75.0.10";
          prefixLength = 24;
        } ];
      };
    };

    useDHCP = lib.mkForce false;

    defaultGateway = "10.75.0.1";

    extraHosts = ''
      127.0.0.1 nextcloud.bitsync.icu
      127.0.0.1 homeassistant.bitsync.icu
      127.0.0.1 radicale.bitsync.icu
      127.0.0.1 pihole.bitsync.icu
      127.0.0.1 radarr.bitsync.icu
      127.0.0.1 sonarr.bitsync.icu
      127.0.0.1 searxng.bitsync.icu
      127.0.0.1 invidious.bitsync.icu
      127.0.0.1 libreddit.bitsync.icu
      127.0.0.1 jellyfin.bitsync.icu
      127.0.0.1 dav.bitsync.icu
      127.0.0.1 nzbget.bitsync.icu
      127.0.0.1 lidarr.bitsync.icu
      127.0.0.1 freshrss.bitsync.icu
      127.0.0.1 firefoxsync.bitsync.icu
      127.0.0.1 adguard.bitsync.icu
      127.0.0.1 bitsync.icu
      127.0.0.1 onlyoffice.bitsync.icu
      127.0.0.1 pufferpanel.bitsync.icu
      127.0.0.1 uptime-kuma.bitsync.icu
      127.0.0.1 gitea.bitsync.icu
      127.0.0.1 etesync.bitsync.icu
      127.0.0.1 nitter.bitsync.icu
      127.0.0.1 pufferpanel-sftp.bitsync.icu
      127.0.0.1 monero.bitsync.icu
      127.0.0.1 readarr.bitsync.icu
      127.0.0.1 nzbhydra2.bitsync.icu
      10.75.0.65 tmjf.duckdns.org
      10.75.0.120 proxmox.bitsync.icu
    '';
  };
}