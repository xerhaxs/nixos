{ config, lib, pkgs, ... }:

let
  StevenBlack = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/8da3793e586f81439cd0ed6fe482977d11c568d6/hosts";
    hash = "sha256-j2J5HNXtsY9LT7I0NP07tH9/vb3nZ5U6gAAjqZeEwP0="; #sha256 lib.fakeSha256;
  };

  malware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/malware.txt";
    hash = "sha256-01WcEqy3R5zebjT17Pk5vtYbPERfq+UwgHBHgYzbwNo=";
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
      tempAddresses = "default";

      useDHCP = false;

      hosts = {
        "10.75.0.1" = [ "fritz.box" ];
        "10.75.0.10" = [ "proxmox.${config.nixos.server.network.nginx.domain}" ];
        "10.75.0.20" = [
          "jellyfin.${config.nixos.server.network.nginx.domain}"
          "nas.${config.nixos.server.network.nginx.domain}"
          "nextcloud.${config.nixos.server.network.nginx.domain}"
          "samba.${config.nixos.server.network.nginx.domain}"
          "syncthing.${config.nixos.server.network.nginx.domain}"
          "truenas.${config.nixos.server.network.nginx.domain}"
          "webdav.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.21" = [
          "glance.${config.nixos.server.network.nginx.domain}"
          "invidious.${config.nixos.server.network.nginx.domain}"
          "kiwix.${config.nixos.server.network.nginx.domain}"
          "lemmy.${config.nixos.server.network.nginx.domain}"
          "libreddit.${config.nixos.server.network.nginx.domain}"
          "moneronode.${config.nixos.server.network.nginx.domain}"
          "murmur.${config.nixos.server.network.nginx.domain}"
          "nitter.${config.nixos.server.network.nginx.domain}"
          "ollama.${config.nixos.server.network.nginx.domain}"
          "pihole.${config.nixos.server.network.nginx.domain}"
          "radicale.${config.nixos.server.network.nginx.domain}"
          "search.${config.nixos.server.network.nginx.domain}"
          "searx.${config.nixos.server.network.nginx.domain}"
          "searxng.${config.nixos.server.network.nginx.domain}"
          "teamspeak.${config.nixos.server.network.nginx.domain}"
          #"dav.${config.nixos.server.network.nginx.domain}"
          #"gitea.${config.nixos.server.network.nginx.domain}"
          #"jellyfin.${config.nixos.server.network.nginx.domain}"
          #"samba.${config.nixos.server.network.nginx.domain}"
          #"webdav.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.22" = [
          "bluemap.4rx.cc"
          "flolserver.${config.nixos.server.network.nginx.domain}"
          "map.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.23" = [
          "lidarr.${config.nixos.server.network.nginx.domain}"
          "nzbhydra.${config.nixos.server.network.nginx.domain}"
          "radarr.${config.nixos.server.network.nginx.domain}"
          "readarr.${config.nixos.server.network.nginx.domain}"
          "sabnzbd.${config.nixos.server.network.nginx.domain}"
          "sonarr.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.25" = [ 
          "haos.${config.nixos.server.network.nginx.domain}"
          "homeassistant.${config.nixos.server.network.nginx.domain}"
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

      nameservers = [ "10.75.0.21" "10.75.0.1" "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
    };
  };
}
