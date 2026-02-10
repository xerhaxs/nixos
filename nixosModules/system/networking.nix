{ config, lib, pkgs, inputs, ... }:

let
  fetchBlocklist = name: inputs.${name};

  enabledBlocklists = [
    "adobe"
    "amazonFireTV"
    "malware"
    "phishing"
    "ransomware"
    "scam"
    "smart-tv"
    "stevenBlack"
    "tiktok"
    "tracking"
    # "ads"
    # "oisd-big"
    # "oisd-small"
    # "redirect"
  ];

  localIP = config.nixos.system.networking.localIP or null;

  mkHostEntries = ip: hosts: 
    let
      effectiveIP = if localIP != null && ip == localIP then "127.0.0.1" else ip;
    in {
      ${effectiveIP} = lib.mkDefault hosts;
    };

  hostEntries = lib.mkMerge [
    (mkHostEntries "10.75.0.1" [ "fritz.box" ])
    (mkHostEntries "10.75.0.10" [ "proxmox.${config.nixos.server.network.nginx.domain}" ])
    (mkHostEntries "10.75.0.20" [
      "jellyfin.${config.nixos.server.network.nginx.domain}"
      "nas.${config.nixos.server.network.nginx.domain}"
      "nextcloud.${config.nixos.server.network.nginx.domain}"
      "samba.${config.nixos.server.network.nginx.domain}"
      "syncthing.${config.nixos.server.network.nginx.domain}"
      "truenas.${config.nixos.server.network.nginx.domain}"
      "webdav.${config.nixos.server.network.nginx.domain}"
    ])
    (mkHostEntries "10.75.0.21" [
      "glance.${config.nixos.server.network.nginx.domain}"
      "homeassistant.${config.nixos.server.network.nginx.domain}"
      "invidious.${config.nixos.server.network.nginx.domain}"
      "kiwix.${config.nixos.server.network.nginx.domain}"
      "languagetool.${config.nixos.server.network.nginx.domain}"
      "lemmy.${config.nixos.server.network.nginx.domain}"
      "libreddit.${config.nixos.server.network.nginx.domain}"
      "moneronode.${config.nixos.server.network.nginx.domain}"
      "murmur.${config.nixos.server.network.nginx.domain}"
      "networkingtoolbox.${config.nixos.server.network.nginx.domain}"
      "nitter.${config.nixos.server.network.nginx.domain}"
      "ollama.${config.nixos.server.network.nginx.domain}"
      "pihole.${config.nixos.server.network.nginx.domain}"
      "radicale.${config.nixos.server.network.nginx.domain}"
      "searxng.${config.nixos.server.network.nginx.domain}"
      #"syncthing.${config.nixos.server.network.nginx.domain}"
      #"dav.${config.nixos.server.network.nginx.domain}"
      #"gitea.${config.nixos.server.network.nginx.domain}"
      #"jellyfin.${config.nixos.server.network.nginx.domain}"
      #"samba.${config.nixos.server.network.nginx.domain}"
      #"webdav.${config.nixos.server.network.nginx.domain}"
    ])
    (mkHostEntries "10.75.0.22" [
      #"bluemap.${config.nixos.server.network.nginx.domain}"
      #"flolserver.${config.nixos.server.network.nginx.domain}"
      #"map.${config.nixos.server.network.nginx.domain}"
    ])
    (mkHostEntries "10.75.0.23" [
      "lidarr.${config.nixos.server.network.nginx.domain}"
      "nzbhydra.${config.nixos.server.network.nginx.domain}"
      "radarr.${config.nixos.server.network.nginx.domain}"
      "readarr.${config.nixos.server.network.nginx.domain}"
      "sabnzbd.${config.nixos.server.network.nginx.domain}"
      "sonarr.${config.nixos.server.network.nginx.domain}"
    ])
    (mkHostEntries "10.75.0.25" [ "haos.${config.nixos.server.network.nginx.domain}" ])
  ];

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

      localIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "10.75.0.21";
        description = "Local IP address of this host. Host entries matching this IP will use 127.0.0.1 instead.";
      };

      blocklists = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable DNS blocklists.";
        };

        urls = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = enabledBlocklists;
          description = "List of blocklist URLs to use.";
        };
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
          macAddress = "stable";
        };
      };
      
      wireless = {
        enable = true;
        userControlled = true;
      };

      enableIPv6 = true;
      tempAddresses = "default";
      useDHCP = false;

      hosts = hostEntries;

      hostFiles = lib.mkIf config.nixos.system.networking.blocklists.enable 
        (map fetchBlocklist config.nixos.system.networking.blocklists.urls);

      defaultGateway = "10.75.0.1";
      defaultGateway6 = "fe80::1";

      nameservers = [ 
        "10.75.0.21" 
        "10.75.0.1" 
        "9.9.9.9" 
        "149.112.112.112" 
        "2620:fe::fe" 
        "2620:fe::9" 
      ];
    };

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [ "networkmanager" ];
    };
  };
}