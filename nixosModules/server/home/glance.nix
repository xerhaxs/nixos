{ config, lib, pkgs, ... }:

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
    services.glance = {
      enable = true;
      openFirewall = false;
      environmentFile = "${config.sops.secrets."truenas-smb/user".path}";
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
                    type = "calendar";
                    first-day-of-week = "monday";
                  }
                  {
                    type = "rss";
                    limit = 32;
                    collapse-after = 3;
                    cache = "24h";
                    feeds = [
                      { url = "https://www.reuters.com/rssFeed/worldNews"; title = "Reuters"; }
                      { url = "https://www.theguardian.com/world/rss"; title = "The Guardian"; }
                      { url = "https://www.tagesschau.de/xml/rss2"; title = "Tagesschau"; }
                      { url = "https://www.heise.de/rss/heise-atom.xml"; title = "Heise Online"; }
                      { url = "https://netzpolitik.org/feed/"; title = "Netzpolitik.org"; }
                      { url = "https://www.kuketz-blog.de/feed/"; title = "Kuketz IT-Blog"; }
                      { url = "https://www.eff.org/rss/updates.xml"; title = "EFF Foundation"; }
                      { url = "https://taz.de/rss.xml"; title = "taz.de"; }
                      { url = "https://restoreprivacy.com/feed/"; title = "RestorePrivacy"; }
                      { url = "https://rss.golem.de/rss.php?feed=RSS2.0"; title = "Golem.de"; }
                      { url = "https://itsfoss.com/feed/"; title = "It's FOSS"; }
                      { url = "https://winfuture.de/rss/news.rdf"; title = "WinFuture"; }
                      { url = "https://www.vice.com/de/rss"; title = "Vice DE"; }
                      { url = "https://www.philomag.de/rss.xml"; title = "Philosophie Magazin"; }
                    ];
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
                  {
                    type = "search";
                    search-engine = "duckduckgo";
                  }
                  {
                    type = "to-do";
                  }
                ];
              }

              {
                size = "full";
                widgets = [
                  {
                    type = "group";
                    widgets = [
                      { type = "hacker-news"; }
                      { type = "lobsters"; }
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
                        services = [
                          { title = "Jellyfin"; url = "https://jellyfin.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Radarr"; url = "https://radarr.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Sonarr"; url = "https://sonarr.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Lidarr"; url = "https://lidarr.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Readarr"; url = "https://readarr.${config.nixos.server.network.nginx.domain}"; }
                          { title = "SABnzbd"; url = "https://sabnzbd.${config.nixos.server.network.nginx.domain}"; }
                          { title = "NZBHydra2"; url = "https://nzbhydra.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Nextcloud"; url = "https://nextcloud.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Radicale"; url = "https://radicale.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Flolserver"; url = "https://flolserver.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Ollama"; url = "https://ollama.${config.nixos.server.network.nginx.domain}"; }
                          { title = "Pi-hole"; url = "https://pihole.${config.nixos.server.network.nginx.domain}/admin"; }
                          { title = "Invidious"; url = "https://invidious.${config.nixos.server.network.nginx.domain}"; }
                        ];
                      }
                      {
                        type = "dns-stats";
                        service = "pihole-v6";
                        url = "https://pihole.${config.nixos.server.network.nginx.domain}/api/v6";
                        #password = "${config.sops.secrets."pihole/password".path}";
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
                    type = "weather";
                    location = "Berlin, Germany";
                    units = "metric";
                    hour-format = "24h";
                  }
                  {
                    type = "markets";
                    markets = [
                      { symbol = "SPY"; name = "S&P 500"; }
                      { symbol = "BTC-USD"; name = "Bitcoin"; }
                      { symbol = "NVDA"; name = "NVIDIA"; }
                      { symbol = "AAPL"; name = "Apple"; }
                      { symbol = "MSFT"; name = "Microsoft"; }
                    ];
                  }
                  {
                    type = "releases";
                    cache = "3d";
                    repositories = [ "xerhaxs/nixos" ];
                  }
                  {
                    type = "bookmarks";
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
