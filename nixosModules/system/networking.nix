{ config, lib, pkgs, ... }:

let
  StevenBlack = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    hash = "sha256-UxY9MHl6umBRT1mz7uVU/HooJAqPjZaeC2nKMXfOoc4="; #sha256 = lib.fakeSha256;
  };

  malware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/malware.txt";
    hash = "sha256-aAIehA/aFUG6lF1H03kQsf2q1uv4g3Jz6bGpr9wBWkU=";
  };

  phishing = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/phishing.txt";
    hash = "sha256-2Vl48tkBVYd+j7ZmYPZCr2rccAqT1dBmxQUcd/WXMRM=";
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
    hash = "sha256-viJsZskvaz1EQxjcZ8CEpznluGDS8WkFIOLUYP5Ksgs=";
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

      useDHCP = true;

      hosts = {
        "10.75.0.1" = [ "fritz.box" ];
        "10.75.0.186" = [
          "ytdl.m4rx.cc"
          "freshrss.m4rx.cc"
          "rss.m4rx.cc"
          "invidious.m4rx.cc"
          "libreddit.m4rx.cc"
          "lidarr.m4rx.cc"
          "nextcloud.m4rx.cc"
          "nitter.m4rx.cc"
          "nzbget.m4rx.cc"
          "nzbhydra.m4rx.cc"
          "pihole.m4rx.cc"
          "radarr.m4rx.cc"
          "sonarr.m4rx.cc"
          "readarr.m4rx.cc"
          "searx.m4rx.cc"
          "searxng.m4rx.cc"
          "search.m4rx.cc"
          "uptime.m4rx.cc"
          "kuma.m4rx.cc"
          "jellyfin.m4rx.cc"
          "collabora.m4rx.cc"
          "syncthing.m4rx.cc"
        ];
        "10.75.0.67" = [
          #"flolserver.m4rx.cc"
          "pufferpanel.m4rx.cc"
          "map.m4rx.cc"
          "analytics.m4rx.cc"
        ];
        "10.75.0.71" = [ 
          "haos.m4rx.cc" 
        ];
        "10.75.0.10" = [ "proxmox.m4rx.cc" ];
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

      nameservers = [ "10.75.0.71" "10.75.0.1" "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    };
  };
}
