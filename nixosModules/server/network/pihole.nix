{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.pihole = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable PiHole.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.pihole.enable {
    services = {
        pihole-ftl = {
          enable = true;
          lists = [
            {
              url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
              url = "https://blocklistproject.github.io/Lists/malware.txt";
              url = "https://blocklistproject.github.io/Lists/phishing.txt";
              url = "https://blocklistproject.github.io/Lists/ransomware.txt";
              url = "https://blocklistproject.github.io/Lists/scam.txt";
              url = "https://blocklistproject.github.io/Lists/tiktok.txt";
              url = "https://blocklistproject.github.io/Lists/tracking.txt" ;
              url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
            }
          ];
          privacyLevel = 0;
          settings = {
            dns = {
              upstreams = [
                "9.9.9.11"
                "2620:fe::11"
                "149.112.112.11"
                "2620:fe::fe:11"
                "2606:4700:4700::1001"
                "2606:4700:4700::1111"
                "1.0.0.1"
                "1.1.1.1"
              ];

              hosts = [
                "10.75.0.20 pihole.m4rx.cc"
                "10.75.0.20 nextcloud.m4rx.cc"
                "10.75.0.20 syncthing.m4rx.cc"
                "10.75.0.20 jellyfin.m4rx.cc"
                "10.75.0.20 ytdl.m4rx.cc"
                "10.75.0.20 freshrss.m4rx.cc"
                "10.75.0.20 rss.m4rx.cc"
                "10.75.0.20 invidious.m4rx.cc"
                "10.75.0.21 libreddit.m4rx.cc"
                "10.75.0.20 lidarr.m4rx.cc"
                "10.75.0.21 nitter.m4rx.cc"
                "10.75.0.23 nzbhydra.m4rx.cc"
                "10.75.0.20 radarr.m4rx.cc"
                "10.75.0.20 sonarr.m4rx.cc"
                "10.75.0.20 readarr.m4rx.cc"
                "10.75.0.20 searx.m4rx.cc"
                "10.75.0.20 searxng.m4rx.cc"
                "10.75.0.20 search.m4rx.cc"
                "10.75.0.20 uptime.m4rx.cc"
                "10.75.0.20 kuma.m4rx.cc"
                "10.75.0.20 collabora.m4rx.cc"
                "10.75.0.21 kiwix.m4rx.cc"
                "10.75.0.20 ollama.m4rx.cc"
                "10.75.0.20 portainer.m4rx.cc"
                "10.75.0.10 proxmox.m4rx.cc"
                "10.75.0.25 haos.m4rx.cc"
                "10.75.0.25 homeassistant.m4rx.cc"
                "10.75.0.20 nas.m4rx.cc"
                "10.75.0.20 truenas.m4rx.cc"
                "10.75.0.20 vaultwarden.m4rx.cc"
                "10.75.0.20 gitea.m4rx.cc"
                "10.75.0.20 filebrowser.m4rx.cc"
                "10.75.0.30 pufferpanel.m4rx.cc"
                "10.75.0.30 flolserver.m4rx.cc"
                "10.75.0.30 map.m4rx.cc"
                "10.75.0.30 bluemap.m4rx.cc"
                "10.75.0.20 nginx.m4rx.cc"
                "10.75.0.20 nginxproxymanager.m4rx.cc"
                "10.75.0.20 proxymanager.m4rx.cc"
                "10.75.0.20 homepage.m4rx.cc"
                "10.75.0.23 sabnzbd.m4rx.cc"
              ];
              
              revServers = [
                "true,10.75.0.0/24,fritz.box"
              ];
            };
          };
          openFirewallDNS = true;
          openFirewallDHCP = true;
          openFirewallWebserver = true;
        };
        pihole-web = {
          enable = true;
          ports = [
            "3334"
          ];
          hostName = "localhost";
        };
      };

    services.nginx = {
      virtualHosts = {
        "pihole.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3334";
          };
        };
      };
    };

    services.ddclient.domains = [
      "pihole.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
