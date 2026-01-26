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
      environmentFile = config.sops.secrets."glance".path;
      settings = {
        server = {
          host = "127.0.0.1";
          port = 5679;
        };
        theme = {
          # catppuccin-mocha
          background-color = "240 21 15";
          contrast-multiplier = 1.2;
          primary-color = "267 84 81";
          positive-color = "115 54 76";
          negative-color = "347 70 65";

          disable-picker = false;
          presets = {
            catppuccin-frappe = {
              background-color = "229 19 23";
              contrast-multiplier = 1.2;
              primary-color = "277 59 76";
              positive-color = "96 44 68";
              negative-color = "359 68 71";
            };
            catppuccin-macchiato = {
              background-color = "232 23 18";
              contrast-multiplier = 1.2;
              primary-color = "267 83 80";
              positive-color = "105 48 72";
              negative-color = "351 74 73";
            };
            catppuccin-latte = {
              light = true;
              background-color = "220 23 95";
              contrast-multiplier = 1.0;
              primary-color = "220 91 54";
              positive-color = "109 58 40";
              negative-color = "347 87 44";
            };
          };
        };
        pages = [
          {
            name = "Glance";
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
                    type = "server-stats";
                    servers = [
                      { type = "local"; name = "NixOS-Server1"; }
                    ];
                  }
                  {
                    type = "dns-stats";
                    service = "pihole-v6";
                    url = "https://pihole.${config.nixos.server.network.nginx.domain}";
                    password = "\${ENV_PIHOLE_PASSWORD}";
                    hour-format = "24h";
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
                        cache = "5m";
                        type = "rss";
                        title = "RSS Feed Overview";
                        limit = 32;
                        style = "detailed-list";
                        preserve-order = false;
                        collapse-after = 5;
                        feeds = [
                          { url = "https://www.reuters.com/world/"; title = "Reuters"; limit = 3; }
                          { url = "https://www.jungewelt.de/feeds/newsticker.rss"; title = "Junge Welt"; limit = 3; }
                          { url = "https://www.tagesschau.de/xml/rss2"; title = "Tagesschau"; limit = 3; }
                          { url = "https://www.heise.de/rss/heise-atom.xml"; title = "Heise Online"; limit = 3; }
                          { url = "https://netzpolitik.org/feed/"; title = "Netzpolitik.org"; limit = 3; }
                          { url = "https://www.kuketz-blog.de/feed/"; title = "Kuketz IT-Blog"; limit = 1; }
                          { url = "https://tarnkappe.info/feed"; title = "Tarnkappe.info"; limit = 2; }
                          { url = "https://www.wired.com/feed/rss"; title = "Wired"; limit = 2; }
                          { url = "https://www.eff.org/rss/updates.xml"; title = "EFF Foundation"; limit = 1; }
                          { url = "https://taz.de/rss.xml"; title = "taz.de"; limit = 3; }
                          { url = "https://rss.golem.de/rss.php?feed=RSS2.0"; title = "Golem.de"; limit = 3; }
                          { url = "https://itsfoss.com/feed/"; title = "It's FOSS"; limit = 1; }
                          { url = "https://winfuture.de/rss/news.rdf"; title = "WinFuture"; limit = 3; }
                        ];
                      }
                      {
                        cache = "5m";
                        type = "rss";
                        title = "RSS Feed Extended";
                        limit = 256;
                        style = "detailed-list";
                        preserve-order = false;
                        collapse-after = 5;
                        feeds = [
                          { url = "http://newsfeed.zeit.de/index"; title = "ZEIT ONLINE"; limit = 3; }
                          { url = "http://www.srf.ch/news/bnf/rss/1646"; title = "SRF"; limit = 3; }
                          { url = "https://anonleaks.net/feed/"; title = "Anonleaks"; limit = 1; }
                          { url = "https://feeds.feedburner.com/AskVG"; title = "AskVG"; limit = 3; }
                          { url = "https://fragdenstaat.de/blog/feed/"; title = "FragDenStaat"; limit = 3; }
                          { url = "https://freiheitsrechte.org/feed/"; title = "Gesellschaft für Freiheitsrechte"; limit = 3; }
                          { url = "https://fridaysforfuture.de/feed/"; title = "Fridays for Future"; limit = 3; }
                          { url = "https://hearthis.at/aweb/podcast/"; title = "aweb"; limit = 1; }
                          { url = "https://itsfoss.com/feed/"; title = "It's FOSS"; limit = 1; }
                          { url = "https://netzpolitik.org/feed/"; title = "Netzpolitik.org"; limit = 3; }
                          { url = "https://restoreprivacy.com/feed/"; title = "Restore Privacy"; limit = 1; }
                          { url = "https://rss.golem.de/rss.php?feed=RSS2.0"; title = "Golem.de"; limit = 3; }
                          { url = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"; title = "New York Times"; limit = 3; }
                          { url = "https://rss.sueddeutsche.de/rss/Topthemen"; title = "SZ"; limit = 3; }
                          { url = "https://tarnkappe.info/feed"; title = "Tarnkappe.info"; limit = 2; }
                          { url = "https://taz.de/rss.xml"; title = "taz.de"; limit = 3; }
                          { url = "https://winfuture.de/rss/news.rdf"; title = "WinFuture"; limit = 3; }
                          { url = "https://www.3dcenter.org/frontpage/feed"; title = "3DCenter.org"; limit = 3; }
                          { url = "https://www.eff.org/rss.xml"; title = "Electronic Frontier Foundation"; limit = 1; }
                          { url = "https://www.eff.org/rss/updates.xml"; title = "EFF Foundation"; limit = 1; }
                          { url = "https://www.faz.net/rss/aktuell/"; title = "FAZ"; limit = 3; }
                          { url = "https://www.handelsblatt.com/contentexport/feed/top-themen/"; title = "Handelsblatt"; limit = 3; }
                          { url = "https://www.heise.de/rss/heise-atom.xml"; title = "Heise Online"; limit = 3; }
                          { url = "https://www.kuketz-blog.de/feed/"; title = "Kuketz IT-Blog"; limit = 1; }
                          { url = "https://www.piratenpartei.de/feed/"; title = "Piratenpartei Deutschland"; limit = 1; }
                          { url = "https://www.reuters.com/world/"; title = "Reuters"; limit = 3; }
                          { url = "https://www.reuters.com/world/"; title = "Reuters"; limit = 3; }
                          { url = "https://www.spiegel.de/index.rss"; title = "DER SPIEGEL"; limit = 3; }
                          { url = "https://www.tagesschau.de/xml/rss2"; title = "Tagesschau"; limit = 3; }
                          { url = "https://www.tagesspiegel.de/contentexport/feed/home"; title = "Tagesspiegel"; limit = 3; }
                          { url = "https://www.theguardian.com/international/rss"; title = "The Guardian"; limit = 3; }
                          { url = "https://www.wired.com/feed/rss"; title = "Wired"; limit = 2; }
                          { url = "https://www.zdf.de/rss/zdf/nachrichten"; title = "ZDFheute"; limit = 3; }
                        ];
                      }
                      {
                        cache = "5m";
                        type = "rss";
                        title = "RSS Feed Linux";
                        limit = 32;
                        style = "detailed-list";
                        preserve-order = false;
                        collapse-after = 5;
                        feeds = [
                          { url = "https://archlinux.org/feeds/news/"; title = "Arch Linux News"; limit = 5; }
                          { url = "https://archlinux.org/feeds/packages/"; title = "Arch Linux Packages"; limit = 5; }
                          { url = "https://discourse.nixos.org/c/announcements/8.rss"; title = "NixOS Discourse Announcements"; limit = 5; }
                          { url = "https://discourse.nixos.org/c/dev/rfc-steering-committee/33.rss"; title = "NixOS Discourse Steering Committee"; limit = 5; }
                          { url = "https://discourse.nixos.org/c/links/12.rss"; title = "NixOS Discourse"; limit = 5; }
                          { url = "https://discourse.nixos.org/c/meta/nixos-foundation/47.rss"; title = "NixOS Discourse"; limit = 5; }
                          { url = "https://discourse.nixos.org/posts.rss"; title = "NixOS Discourse Posts"; limit = 5; }
                          { url = "https://discourse.nixos.org/t/breaking-changes-announcement-for-unstable/17574.rss"; title = "NixOS Discourse Meta"; limit = 5; }
                          { url = "https://nixos.org/blog/announcements-rss.xml"; title = "NixOS Discourse Blog Announcements"; limit = 3; }
                          { url = "https://nixos.org/blog/newsletters-rss.xml"; title = "NixOS Discourse Newsletters"; limit = 3; }
                          { url = "https://weekly.nixos.org/feeds/all.atom.xml"; title = "NixOS Discourse Weekly"; limit = 1; }
                          { url = "https://weekly.nixos.org/feeds/all.rss.xml"; title = "NixOS Discourse Weekly"; limit = 1; }
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
                      { type = "reddit"; subreddit = "de"; show-thumbnails = true; cache = "5m"; }
                      { type = "reddit"; subreddit = "technology"; show-thumbnails = true; cache = "5m"; }
                      { type = "reddit"; subreddit = "selfhosted"; show-thumbnails = true; cache = "5m"; }
                    ];
                  }
                  {
                    type = "group";
                    title = "Server Monitoring";
                    widgets = [
                      {
                        type = "monitor";
                        cache = "1m";
                        sites = [ # di for Dashboard icons https://github.com/homarr-labs/dashboard-icons
                          { title = "Pi-hole"; url = "https://pihole.${config.nixos.server.network.nginx.domain}"; icon = "di:pi-hole"; }
                          { title = "Home Assistant"; url = "https://haos.${config.nixos.server.network.nginx.domain}"; icon = "di:home-assistant"; }
                          { title = "Nextcloud"; url = "https://nextcloud.${config.nixos.server.network.nginx.domain}"; icon = "di:nextcloud"; }

                          { title = "Jellyfin"; url = "https://jellyfin.${config.nixos.server.network.nginx.domain}"; icon = "di:jellyfin"; }
                          { title = "SABnzbd"; url = "https://sabnzbd.${config.nixos.server.network.nginx.domain}"; icon = "di:sabnzbd"; }
                          { title = "NZBHydra2"; url = "https://nzbhydra.${config.nixos.server.network.nginx.domain}"; icon = "di:nzbhydra2"; }

                          { title = "Radarr"; url = "https://radarr.${config.nixos.server.network.nginx.domain}"; icon = "di:radarr"; }
                          { title = "Sonarr"; url = "https://sonarr.${config.nixos.server.network.nginx.domain}"; icon = "di:sonarr"; }
                          { title = "Lidarr"; url = "https://lidarr.${config.nixos.server.network.nginx.domain}"; icon = "di:lidarr"; }

                          { title = "Readarr"; url = "https://readarr.${config.nixos.server.network.nginx.domain}"; icon = "di:readarr"; }
                          { title = "Ollama"; url = "https://ollama.${config.nixos.server.network.nginx.domain}"; icon = "di:ollama"; }
                          { title = "SearXNG"; url = "https://searxng.${config.nixos.server.network.nginx.domain}"; icon = "di:searxng"; }

                          { title = "Invidious"; url = "https://invidious.${config.nixos.server.network.nginx.domain}"; icon = "di:invidious"; }
                          { title = "LibReddit"; url = "https://libreddit.${config.nixos.server.network.nginx.domain}"; icon = "di:redlib"; }
                          { title = "Nitter"; url = "https://nitter.${config.nixos.server.network.nginx.domain}"; icon = "di:nitter"; }
                          
                          { title = "Radicale"; url = "https://radicale.${config.nixos.server.network.nginx.domain}"; icon = "di:radicale"; }
                          { title = "Flolserver"; url = "https://flolserver.${config.nixos.server.network.nginx.domain}"; icon = "di:minecraft"; allow-insecure = true; }
                        ];
                      }
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
                      { timezone = "${config.nixos.system.locals.timezone}"; label = "Local Time"; }
                      { timezone = "America/New_York"; label = "New York"; }
                      { timezone = "Asia/Tokyo"; label = "Tokyo"; }
                    ];
                  }
                  {
                    type = "weather";
                    location = "\${ENV_LOCATION}";
                    units = "metric";
                    hour-format = "24h";
                  }
                  {
                    type = "markets";
                    markets = [
                      { symbol = "VWCE.DE"; name = "FTSE All-World"; }
                      { symbol = "IWDA.AS"; name = "MSCI World ETF"; }
                      { symbol = "RHM.DE"; name = " Rheinmetall"; }
                      { symbol = "XMR-EUR"; name = "Monero"; }
                      { symbol = "BTC-EUR"; name = "Bitcoin"; }
                      { symbol = "ETH-EUR"; name = "Ethereum"; }
                      { symbol = "GC=F"; name = "Gold"; }
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
                          { title = "Wikipedia"; url = "https://www.wikipedia.org/"; }
                          { title = "Le Chat"; url = "https://chat.mistral.ai/chat"; }
                          { title = "Language Tool"; url = "https://languagetool.org/"; }
                          { title = "DeepL"; url = "https://www.deepl.com/"; }
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
