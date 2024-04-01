{ config, lib, pkgs, ... }:

let
  StevenBlack = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
    hash = "sha256-yznCfsT7/XJ+Tts/zBx7hF3XD4uiYZoAGOk06POtufg="; #sha256 = lib.fakeSha256;
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
  networking = {

    networkmanager.enable = true;
    
    wireless.userControlled.enable = true;

    enableIPv6 = false;

    useDHCP = true;

    hosts = {
      "10.75.0.1" = [ "fritz.box" ];
      "10.75.0.10" = [
        "adguard.bitsync.icu"
        "dav.bitsync.icu"
        "etesync.bitsync.icu"
        "firefoxsync.bitsync.icu"
        "freshrss.bitsync.icu"
        "gitea.bitsync.icu"
        "homeassistant.bitsync.icu"
        "invidious.bitsync.icu"
        "jellyfin.bitsync.icu"
        "libreddit.bitsync.icu"
        "lidarr.bitsync.icu"
        "monero.bitsync.icu"
        "nextcloud.bitsync.icu"
        "nitter.bitsync.icu"
        "nzbget.bitsync.icu"
        "nzbhydra2.bitsync.icu"
        "onlyoffice.bitsync.icu"
        "pufferpanel-sftp.bitsync.icu"
        "pufferpanel.bitsync.icu"
        "radarr.bitsync.icu"
        "radicale.bitsync.icu"
        "readarr.bitsync.icu"
        "searxng.bitsync.icu"
        "sonarr.bitsync.icu"
        "uptime-kuma.bitsync.icu"
        "vaultwarden.bitsync.icu"
      ];
      "10.75.0.65" = [ 
        "haos.bitsync.icu" 
        "tmjf.duckdns.org"
      ];
      "10.75.0.120" = [ "proxmox.bitsync.icu" ];
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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    defaultGateway = "10.75.0.1";

    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
  };
}
