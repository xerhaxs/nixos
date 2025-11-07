{ config, lib, pkgs, ... }:

let
  jellyfin = ./icons/png/jellyfin.png;
in

{
  options.nixos = {
    server.home.glance = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable glance.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.glance.enable {
    systemd.services.webdav.serviceConfig.EnvironmentFile = [
      config.sops.secrets."pihole/password".path
    ];

    services.glance = {
      enable = true;
      openFirewall = false;
      settings = {
        server = {
          host = "127.0.0.1";
          port = 5679;
        };
        pages = [
          {
            name = "Glance Home";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "to-do";
                  }
                  {
                    type = "calendar";
                    first-day-of-week = "monday";
                  }
                  {
                    type = "twitch-channels";
                    channels = [
                      "sparkofphoenixtv"
                      "thejocraft_live"
                      "staiy"
                      "gronkh"
                      "christitustech"
                      "mauriceweber"
                    ];
                  }
                ];
              }

              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    search-engine = "duckduckgo";
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "rss";
                        title = "RSS Feed";
                        limit = 32;
                        style = "detailed-list";
                        preserve-order = false;
                        collapse-after = 5;
                        feeds = [
                          { url = "https://www.reuters.com/world/"; title = "Reuters"; limit = 3; }
                          { url = "https://www.tagesschau.de/xml/rss2"; title = "Tagesschau"; limit = 3; }
                          { url = "https://www.heise.de/rss/heise-atom.xml"; title = "Heise Online"; limit = 3; }
                          { url = "https://netzpolitik.org/feed/"; title = "Netzpolitik.org"; limit = 3; }
                          { url = "https://www.kuketz-blog.de/feed/"; title = "Kuketz IT-Blog"; limit = 1; }
                          { url = "https://tarnkappe.info/feed"; title = "Tarnkappe.info"; limit = 1; }
                          { url = "https://www.wired.com/feed/rss"; title = "Wired"; limit = 2; }
                          { url = "https://www.eff.org/rss/updates.xml"; title = "EFF Foundation"; limit = 1; }
                          { url = "https://taz.de/rss.xml"; title = "taz.de"; limit = 3; }
                          { url = "https://rss.golem.de/rss.php?feed=RSS2.0"; title = "Golem.de"; limit = 3; }
                          { url = "https://itsfoss.com/feed/"; title = "It's FOSS"; limit = 1; }
                          { url = "https://winfuture.de/rss/news.rdf"; title = "WinFuture"; limit = 3; }
                          { url = "https://www.philomag.de/rss.xml"; title = "Philosophie Magazin"; limit = 1; }
                        ];
                      }
                      { 
                        type = "hacker-news";
                      }
                      {
                        type = "lobsters";
                      }
                    ];
                  }
                  {
                    type = "videos";
                    channels = [
                      "UC5NOEUbkLheQcaaRldYW5GA" # Tagesschau
                      "UChqUTb7kYRX8-EiaN3XFrSQ" # Reuters
                      "UCLLibJTCy3sXjHLVaDimnpQ" # ARTEde
                      "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                      "UC3swwxiALG5c0Tvom83tPGg" # Two Steps From Hell
                    ];
                  }
                  {
                    type = "group";
                    widgets = [
                      { type = "reddit"; subreddit = "de"; show-thumbnails = true; }
                      { type = "reddit"; subreddit = "technology"; show-thumbnails = true; }
                      { type = "reddit"; subreddit = "selfhosted"; show-thumbnails = true; }
                    ];
                  }
                  {
                    type = "group";
                    title = "Server Monitoring";
                    widgets = [
                      {
                        type = "monitor";
                        cache = "1m";
                        sites = [
                          { title = "Jellyfin"; url = "https://jellyfin.${config.nixos.server.network.nginx.domain}"; icon = "${jellyfin}"; }
                          { title = "Radarr"; url = "https://radarr.${config.nixos.server.network.nginx.domain}"; icon = ./icons/png/jellyfin.png; }
                          { title = "Sonarr"; url = "https://sonarr.${config.nixos.server.network.nginx.domain}"; icon = "icons/svg/sonarr.svg"; }
                          { title = "Lidarr"; url = "https://lidarr.${config.nixos.server.network.nginx.domain}"; icon = ./icons/svg/lidarr.svg; }
                          { title = "Readarr"; url = "https://readarr.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/readarr.svg"; }
                          { title = "SABnzbd"; url = "https://sabnzbd.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/sabnzbd.svg"; }
                          { title = "NZBHydra2"; url = "https://nzbhydra.${config.nixos.server.network.nginx.domain}"; icon = "icons/svg/nzbhydra2.svg"; }
                          { title = "Nextcloud"; url = "https://nextcloud.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/nextcloud.svg"; }
                          { title = "Radicale"; url = "https://radicale.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/radicale.svg"; }
                          { title = "Flolserver"; url = "https://flolserver.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/minecraft.svg"; allow-insecure = true; }
                          { title = "Ollama"; url = "https://ollama.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/ollama.svg"; }
                          { title = "Pi-hole"; url = "https://pihole.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/pi-hole.svg"; }
                          { title = "Invidious"; url = "https://invidious.${config.nixos.server.network.nginx.domain}"; icon = "./icons/svg/invidious.svg"; }
                        ];
                      }
                      {
                        type = "dns-stats";
                        service = "pihole-v6";
                        url = "https://pihole.${config.nixos.server.network.nginx.domain}";
                        password = "{env}ENV_PASSWORD";
                        hour-format = "24h";
                      }
                      #{
                      #  type = "server-stats";
                      #  servers = [
                      #    { name = "NixOS-Server1"; url = "https://server.${config.nixos.server.network.nginx.domain}"; }
                      #  ];
                      #}
                    ];
                  }
                ];
              }

              {
                size = "small";
                widgets = [
                  {
                    type = "clock";
                    hour-format = "24h";
                    timezones = [
                      { timezone = "Europe/Berlin"; label = "Berlin"; }
                      { timezone = "America/New_York"; label = "New York"; }
                      { timezone = "Asia/Tokyo"; label = "Tokyo"; }
                    ];
                  }
                  {
                    type = "weather";
                    location = "Berlin, Germany";
                    units = "metric";
                    hour-format = "24h";
                  }
                  {
                    type = "markets";
                    markets = [
                      { symbol = "URTH"; name = "MSCI World ETF"; }
                      { symbol = "U1IH"; name = "UniGlobal"; }
                      { symbol = "RHM"; name = " Rheinmetall"; }
                      { symbol = "BTC-USD"; name = "Bitcoin"; }
                      { symbol = "ETH-USD"; name = "Ethereum"; }
                      { symbol = "XMR-USD"; name = "Monero"; }
                    ];
                  }
                  {
                    type = "repository";
                    repository = "xerhaxs/nixos";
                    pull-requests-limit = 5;
                    issues-limit = 5;
                    commits-limit = 5;
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        title = "Links";
                        links = [
                          { title = "ChatGPT"; url = "https://chat.openai.com"; }
                          { title = "Netflix"; url = "https://netflix.com"; }
                        ];
                      } 
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    services.nginx = {
      virtualHosts = {
        "glance.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = { 
            proxyPass = "http://localhost:5679";
          };
        };
      };
    };
  };
}
