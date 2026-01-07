{ config, lib, pkgs, ... }:

let
  StevenBlack = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/StevenBlack/hosts/8da3793e586f81439cd0ed6fe482977d11c568d6/hosts";
    hash = "sha256-j2J5HNXtsY9LT7I0NP07tH9/vb3nZ5U6gAAjqZeEwP0="; #sha256 lib.fakeSha256;
  };

  malware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/malware.txt";
    hash = "sha256-pnIYcijo5O5fy+MH66PWhDVNpDgmXupb5T+yEAukMHA=";
  };

  phishing = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/phishing.txt";
    hash = "sha256-x6YYuyb9eHHsxj6jwVwGJHHpNcmAdP4vm35PtFZh1vU=";
  };

  ransomware = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/ransomware.txt";
    hash = "sha256-hlHvIdcIeQVoHJcuydRct+k0Q7BGS06HLcofJEk3SC8=";
  };

  redirect = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/redirect.txt";
    hash = "sha256-DV9fVdlF7X+t7mpdouEJsx6fHXYKrz50FxrXSGGzuwo=";
  };

  scam = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/scam.txt";
    hash = "sha256-h1TWvuCIB3hO7wwaVyCRJf/47q2iXq/uZ8e9W96mThk=";
  };

  tiktok = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/tiktok.txt";
    hash = "sha256-JSLM2sve4vJRpke0Ep0U70XLlyjtQAimvqNLu5Ewk+Y=";
  };

  tracking = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/tracking.txt";
    hash = "sha256-ZYNi6hv2nOGQJgKm0IONVCpbf3fWGMV3q2+3fnZHjyY=";
  };

  smart-tv = pkgs.fetchurl {
    url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
    hash = "sha256-wHLAmqOUWqSzOB2WNee8/hYwdfkyiH6Kdg5VP7TPdho=";
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
        enable = true;
        userControlled.enable = true;
      };

      enableIPv6 = true;
      tempAddresses = "default";

      useDHCP = false;

      hosts = {
        "10.75.0.1" = lib.mkDefault [ "fritz.box" ];
        "10.75.0.10" = lib.mkDefault [ "proxmox.${config.nixos.server.network.nginx.domain}" ];
        "10.75.0.20" = lib.mkDefault [
          "jellyfin.${config.nixos.server.network.nginx.domain}"
          "nas.${config.nixos.server.network.nginx.domain}"
          "nextcloud.${config.nixos.server.network.nginx.domain}"
          "samba.${config.nixos.server.network.nginx.domain}"
          "syncthing.${config.nixos.server.network.nginx.domain}"
          "truenas.${config.nixos.server.network.nginx.domain}"
          "webdav.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.21" = lib.mkDefault [
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
          "searxng.${config.nixos.server.network.nginx.domain}"
          "teamspeak.${config.nixos.server.network.nginx.domain}"
          #"dav.${config.nixos.server.network.nginx.domain}"
          #"gitea.${config.nixos.server.network.nginx.domain}"
          #"jellyfin.${config.nixos.server.network.nginx.domain}"
          #"samba.${config.nixos.server.network.nginx.domain}"
          #"webdav.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.22" = lib.mkDefault [
          #"bluemap.4rx.cc"
          #"flolserver.${config.nixos.server.network.nginx.domain}"
          #"map.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.23" = lib.mkDefault [
          "lidarr.${config.nixos.server.network.nginx.domain}"
          "nzbhydra.${config.nixos.server.network.nginx.domain}"
          "radarr.${config.nixos.server.network.nginx.domain}"
          "readarr.${config.nixos.server.network.nginx.domain}"
          "sabnzbd.${config.nixos.server.network.nginx.domain}"
          "sonarr.${config.nixos.server.network.nginx.domain}"
        ];
        "10.75.0.25" = lib.mkDefault [ 
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

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [
        "networkmanager"
      ];
    };
  };
}
