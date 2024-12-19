{ config, lib, pkgs, ... }:

let
  StevenBlack = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    hash = "sha256-eWaSZusdZs9Bg+cdPKJSFyHZAy4VxCGPzlxJTK2rSaY="; #sha256 lib.fakeSha256;
  };

  malware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/malware.txt";
    hash = "sha256-HWNBa8k34NLDetBgQGaxrnp5VhC9EnZStFr/4ndceC4=";
  };

  phishing = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/phishing.txt";
    hash = "sha256-ls6xrZZk8VvGcqFDgloaMM82qDVfAJuAGJJvwry9dOw=";
  };

  ransomware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/ransomware.txt";
    hash = "sha256-yQ/UM9BV4VP8guGh0YPJhcZae70apN7RuuyaeqiuSkE=";
  };

  redirect = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/redirect.txt";
    hash = "sha256-DV9fVdlF7X+t7mpdouEJsx6fHXYKrz50FxrXSGGzuwo=";
  };

  scam = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/scam.txt";
    hash = "sha256-S+lM4suvBkl4TXCNZ3HG3mcM81PB7dQjFg0MKSWinDs=";
  };

  tiktok = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/tiktok.txt";
    hash = "sha256-ROLCPlei4fK18y0BGzaJUxA4XctPGAInnMp9NFWNFbA=";
  };

  tracking = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/tracking.txt";
    hash = "sha256-TWbr0w4/w3mKoDOds91+9+GynthDQU7IqzIUvBIQZyE=";
  };

  smart-tv = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
    hash = "sha256-jCsuPWVuJSO4m9p98lHGDI9mlVXReruMTaUc0CYDsXw=";
  };

  adobe = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/adobe.txt";
    hash = "sha256-plsZmL5edWsiSPop6NG5yrAxuOc4cBiYsfKQ9pA/N7k=";
  };

  ads = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/ads.txt";
    hash = "sha256-Ga69x1MkF5Rzyw8ZJXDBlVnBSGrnpGIBkdCvHjF2kCU=";
  };

  AmazonFireTV = pkgs.fetchurl {
    url = "https://perflyst.github.io/PiHoleBlocklist/AmazonFireTV.txt";
    hash = "sha256-ItcZzehy1RNl81DhQuECvlxT3L1minlcD1HBTR2BL7s=";
  };

  oisd-small = pkgs.fetchurl {
    url = "https://small.oisd.nl/";
    hash = "sha256-+RPBCvaVIhF82GFD2VpQVimItRzTkJWFYpFDBbhmDBw=";
  };

  oisd-big = pkgs.fetchurl {
    url = "https://big.oisd.nl/";
    hash = "sha256-UgdkJJvrDeEwA/2eKFr4Y1prygnNSvmLZ0sWhHrdOOM=";
  };
in

{
  options.nixos = {
    system.networking = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable networking and network config.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.networking.enable {
    networking = {
      networkmanager = {
        enable = true;
        dns = "default";
        wifi = {
          scanRandMacAddress = true;
          powersave = false;
          macAddress = "stable"; #"random";
        };
      };
      
      wireless = {
        enable = false;
        userControlled.enable = true;
      };

      enableIPv6 = true;

      useDHCP = false;

      hosts = {
        "10.75.0.1" = [ "fritz.box" ];
        "10.75.0.10" = [ "proxmox.m4rx.cc" ];
        "10.75.0.20" = [
          "collabora.m4rx.cc"
          "filebrowser.m4rx.cc"
          "freshrss.m4rx.cc"
          "gitea.m4rx.cc"
          "invidious.m4rx.cc"
          "jellyfin.m4rx.cc"
          "kuma.m4rx.cc"
          "lidarr.m4rx.cc"
          "nas.m4rx.cc"
          "nextcloud.m4rx.cc"
          "portainer.m4rx.cc"
          "radarr.m4rx.cc"
          "readarr.m4rx.cc"
          "rss.m4rx.cc"
          "samba.m4rx.cc"
          "search.m4rx.cc"
          "searx.m4rx.cc"
          "searxng.m4rx.cc"
          "sonarr.m4rx.cc"
          "syncthing.m4rx.cc"
          "truenas.m4rx.cc"
          "uptime.m4rx.cc"
          "vaultwarden.m4rx.cc"
          "webdav.m4rx.cc"
          "ytdl.m4rx.cc"
        ];
        "10.75.0.21" = [
          "adguard.m4rx.cc"
          #"collabora.m4rx.cc"
          "dav.m4rx.cc"
          "etesync.m4rx.cc"
          "firefoxsync.m4rx.cc"
          #"freshrss.m4rx.cc"
          #"gitea.m4rx.cc"
          #"invidious.m4rx.cc"
          #"jellyfin.m4rx.cc"
          "kiwix.m4rx.cc"
          #"kuma.m4rx.cc"
          "lemmy.m4rx.cc"
          "libreddit.m4rx.cc"
          "mailserver.m4rx.cc"
          "mastodon.m4rx.cc"
          "moneronode.m4rx.cc"
          "murmur.m4rx.cc"
          #"nextcloud.m4rx.cc"
          "nitter.m4rx.cc"
          "onlyoffice.m4rx.cc"
          "peertube.m4rx.cc"
          "pihole.m4rx.cc"
          "pixelfed.m4rx"
          "radicale.m4rx.cc"
          #"rss.m4rx.cc"
          #"samba.m4rx.cc"
          #"search.m4rx.cc"
          #"searx.m4rx.cc"
          #"searxng.m4rx.cc"
          "teamspeak.m4rx.cc"
          #"uptime.m4rx.cc"
          #"vaultwarden.m4rx.cc"
          #"webdav.m4rx.cc"
        ];
        "10.75.0.22" = [
          #"bluemap.4rx.cc"
          #"creativeserver.m4rx.cc"
          #"flolserver.m4rx.cc"
          #"map.m4rx.cc"
          #"pufferpanel.m4rx.cc"
          #"pvpserver.m4rx.cc"
          #"silverageserver.m4rx.cc"
          #"testserver.m4rx.cc"
        ];
        "10.75.0.23" = [
          #"lidarr.m4rx.cc"
          "nzbget.m4rx.cc"
          "nzbhydra.m4rx.cc"
          #"radarr.m4rx.cc"
          #"readarr.m4rx.cc"
          "sabnzbd.m4rx.cc"
          #"sonarr.m4rx.cc"
        ];
        "10.75.0.25" = [ 
          "haos.m4rx.cc"
          "homeassistant.m4rx.cc"
        ];
      };

      hostFiles = [
        StevenBlack
        malware
        phishing
        ransomware
        #redirect
        scam
        tiktok
        tracking
        smart-tv
        adobe
        #ads
        AmazonFireTV
        #oisd-small
        #oisd-big
      ];

      defaultGateway = "10.75.0.1";
      defaultGateway6 = "fe80::1";

      nameservers = [ "10.75.0.25" "10.75.0.1" "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    };
  };
}
