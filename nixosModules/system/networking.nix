{
  config,
  lib,
  pkgs,
  inputs,
  userName,
  ...
}:

let
  cfg = config.nixos.system.networking;
  homeDomain = config.nixos.site.homeDomain;
  publicDomain = config.nixos.site.domain;

  # Files of the flake inputs, flake.lock pins them and nix flake update refreshes them.
  blocklistFiles = {
    ads = "${inputs.blocklistproject}/ads.txt";
    adobe = "${inputs.blocklistproject}/adobe.txt";
    amazonFireTV = "${inputs.perflyst}/AmazonFireTV.txt";
    malware = "${inputs.blocklistproject}/malware.txt";
    phishing = "${inputs.blocklistproject}/phishing.txt";
    ransomware = "${inputs.blocklistproject}/ransomware.txt";
    redirect = "${inputs.blocklistproject}/redirect.txt";
    scam = "${inputs.blocklistproject}/scam.txt";
    smart-tv = "${inputs.blocklistproject}/smart-tv.txt";
    stevenBlack = "${inputs.stevenBlack}/hosts";
    tiktok = "${inputs.blocklistproject}/tiktok.txt";
    tracking = "${inputs.blocklistproject}/tracking.txt";
  };

  fetchBlocklist = name: blocklistFiles.${name};

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
    # "redirect"
  ];

  localIP = cfg.localIP;

  mkHostEntries =
    ip: hosts:
    let
      effectiveIP = if localIP != null && ip == localIP then "127.0.0.1" else ip;
    in
    {
      ${effectiveIP} = lib.mkDefault hosts;
    };

  hostEntries = lib.mkMerge (lib.mapAttrsToList mkHostEntries cfg.lan.hosts);

  # The VPS have no name in the LAN, ssh and deploys reach them by name on their public addresses.
  vpsEntries = lib.mkMerge (
    lib.mapAttrsToList
      (
        name: net:
        lib.genAttrs (lib.filter (ip: ip != null) [
          (net.ipv4 or null)
          (net.ipv6 or null)
        ]) (_: [ name ])
      )
      (
        lib.filterAttrs (name: _: name != config.networking.hostName) {
          NixOS-ServerPublic = config.nixos.site.serverPublic;
          NixOS-ServerGaming = config.nixos.site.serverGaming;
        }
      )
  );

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

      networkmanager.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Use NetworkManager to manage network connections.";
      };

      lan = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = "Host is part of the home LAN (gateway, nameservers and local host entries).";
        };

        staticRouting = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = "Set gateway and nameservers of the home LAN statically (disable on laptops, they get both by DHCP).";
        };

        subnet = lib.mkOption {
          type = lib.types.str;
          default = "10.75.0.0/24";
          description = "Subnet of the home LAN.";
        };

        gateway = lib.mkOption {
          type = lib.types.str;
          default = "10.75.0.1";
          description = "IPv4 gateway of the home LAN.";
        };

        gateway6 = lib.mkOption {
          type = lib.types.str;
          default = "fe80::1";
          description = "IPv6 gateway of the home LAN.";
        };

        nameservers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "10.75.0.21"
            "10.75.0.1"
            "9.9.9.9"
            "149.112.112.112"
            "2620:fe::fe"
            "2620:fe::9"
          ];
          description = "Nameservers used in the home LAN.";
        };

        hosts = lib.mkOption {
          type = lib.types.attrsOf (lib.types.listOf lib.types.str);
          default = {
            "10.75.0.1" = [ "fritz.box" ];
            "10.75.0.21" = [
              "NixOS-Server1"
              "cockpit.${homeDomain}"
              "comfyui.${homeDomain}"
              "dav.${homeDomain}"
              "forgejo.${homeDomain}"
              "glance.${homeDomain}"
              "grafana.${homeDomain}"
              "homeassistant.${homeDomain}"
              "homebox.${homeDomain}"
              "invidious.${homeDomain}"
              "jellyfin.${homeDomain}"
              "kiwix.${homeDomain}"
              "languagetool.${homeDomain}"
              "libreddit.${homeDomain}"
              "libretranslate.${homeDomain}"
              "lidarr.${homeDomain}"
              "linkwarden.${homeDomain}"
              #"moneronode.${homeDomain}"
              "networkingtoolbox.${homeDomain}"
              "nzbhydra.${homeDomain}"
              "ollama.${homeDomain}"
              "pihole.${homeDomain}"
              "radarr.${homeDomain}"
              "radicale.${homeDomain}"
              "readarr.${homeDomain}"
              "sabnzbd.${homeDomain}"
              "searxng.${homeDomain}"
              "sonarr.${homeDomain}"
              "syncthing.${homeDomain}"
              "webdav.${homeDomain}"
            ];
            "10.100.0.1" = [
              "code.${publicDomain}"
            ];
          };
          defaultText = lib.literalExpression "gateway, services of NixOS-Server1 on nixos.site.homeDomain, code.<nixos.site.domain> on the wireguard ip of NixOS-ServerPublic";
          description = "Local DNS records (IP -> hostnames), used for /etc/hosts and pihole.";
        };
      };

      dnssec = lib.mkOption {
        type = lib.types.bool;
        default = config.nixos.desktop.enable;
        defaultText = lib.literalExpression "config.nixos.desktop.enable";
        description = "Validate DNSSEC in systemd-resolved (allow-downgrade).";
      };

      privateDns = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Ignore the DNS servers of the networks (DHCP) and use Quad9 with DNS over TLS (strict). Pi-hole is used through WireGuard when it is up. Captive portals need a manual workaround.";
      };

      macRandomization = {
        wifi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Random MAC address for every wifi connection (home networks keep the permanent one).";
        };

        ethernet = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Random MAC address for every wired connection.";
        };
      };

      wifi = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Provide the wifi networks from sops (secret wifi) as read-only NetworkManager profiles.";
        };

        networks = lib.mkOption {
          type = lib.types.attrsOf lib.types.int;
          default = {
            HOME = 10;
          };
          description = "Network name -> autoconnect priority. The sops secret wifi contains ENV_<NAME>_SSID and ENV_<NAME>_PSK for each network.";
        };

        homeNetworks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "HOME" ];
          description = "Networks of the sops wifi profiles which use the permanent MAC address (same MAC and DHCP lease on every boot).";
        };

        wpa3Networks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Networks of the sops wifi profiles which only use WPA3 (SAE) with required management frame protection. The others use WPA2/WPA3 transition (NetworkManager picks SAE where the access point offers it) with optional protection.";
        };
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
          description = "Names of the blocklists to use.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = lib.mkIf cfg.networkmanager.enable {
        enable = true;
        dns = if cfg.privateDns then lib.mkForce "none" else lib.mkDefault "systemd-resolved";
        wifi = {
          scanRandMacAddress = true;
          powersave = false;
          macAddress = if cfg.macRandomization.wifi then "random" else "stable";
        };
        ethernet.macAddress = lib.mkIf cfg.macRandomization.ethernet "random";

        ensureProfiles = lib.mkIf cfg.wifi.enable {
          environmentFiles = [ config.sops.secrets."wifi".path ];
          profiles = lib.mapAttrs (name: priority: {
            connection = {
              id = "\$ENV_${name}_SSID";
              type = "wifi";
              autoconnect = true;
              autoconnect-priority = priority;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "\$ENV_${name}_SSID";
              cloned-mac-address = if lib.elem name cfg.wifi.homeNetworks then "permanent" else "random";
            };
            wifi-security =
              if lib.elem name cfg.wifi.wpa3Networks then
                {
                  key-mgmt = "sae";
                  pmf = 3;
                  psk = "\$ENV_${name}_PSK";
                }
              else
                {
                  key-mgmt = "wpa-psk";
                  pmf = 2;
                  psk = "\$ENV_${name}_PSK";
                };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "stable-privacy";
            };
          }) cfg.wifi.networks;
        };
      };

      enableIPv6 = true;
      tempAddresses = "default";
      useDHCP = false;

      hosts = lib.mkMerge [
        (lib.mkIf cfg.lan.enable hostEntries)
        vpsEntries
      ];

      hostFiles = lib.mkIf cfg.blocklists.enable (map fetchBlocklist cfg.blocklists.urls);

      defaultGateway = lib.mkIf (cfg.lan.enable && cfg.lan.staticRouting) cfg.lan.gateway;
      defaultGateway6 = lib.mkIf (cfg.lan.enable && cfg.lan.staticRouting) cfg.lan.gateway6;

      nameservers =
        if cfg.privateDns then
          [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
            "2620:fe::fe#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
          ]
        else
          lib.mkIf (cfg.lan.enable && cfg.lan.staticRouting) cfg.lan.nameservers;
    };

    sops.secrets."wifi" = lib.mkIf cfg.wifi.enable {
      restartUnits = [
        "NetworkManager-ensure-profiles.service"
        "NetworkManager-remove-duplicate-wifi.service"
      ];
    };

    # Saved profiles (Plasma, older installs) with the SSID of a declared network compete with the
    # declarative one and use other security and MAC settings. Only those are removed, other
    # networks stay.
    systemd.services.NetworkManager-remove-duplicate-wifi = lib.mkIf cfg.wifi.enable {
      description = "Remove saved WiFi profiles that duplicate a declarative one";
      wantedBy = [ "multi-user.target" ];
      after = [ "NetworkManager-ensure-profiles.service" ];
      requires = [ "NetworkManager-ensure-profiles.service" ];
      before = [ "network-online.target" ];
      path = [ config.networking.networkmanager.package ];
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.sops.secrets."wifi".path;
      };
      script = ''
        declared=(${
          lib.concatMapStringsSep " " (name: ''"''${ENV_${name}_SSID:-}"'') (lib.attrNames cfg.wifi.networks)
        })
        nmcli -t -f UUID,TYPE,FILENAME connection show | while IFS=: read -r uuid type file; do
          [[ $type == 802-11-wireless && $file == /etc/NetworkManager/system-connections/* ]] || continue
          ssid=$(nmcli -g 802-11-wireless.ssid connection show uuid "$uuid")
          for wanted in "''${declared[@]}"; do
            if [[ -n $wanted && $ssid == "$wanted" ]]; then
              echo "removing saved duplicate of $ssid ($uuid)"
              nmcli connection delete uuid "$uuid"
            fi
          done
        done
      '';
    };

    services.resolved.enable = lib.mkDefault true;
    services.resolved.settings.Resolve = {
      DNSSEC = lib.mkIf cfg.dnssec "allow-downgrade";
      DNSOverTLS = if cfg.privateDns then "true" else lib.mkIf cfg.dnssec "opportunistic";
    };

    users.users."${userName}" = lib.mkIf cfg.networkmanager.enable {
      extraGroups = [ "networkmanager" ];
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = lib.optionals cfg.networkmanager.enable [
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
      ];
    };
  };
}
