{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Nginx.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.nginx.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
      #"bitsync.icu" = {
      #  forceSSL = true;
      #  enableACME = true;
      #  acmeRoot = null;
      #  kTLS = true;
      #  http2 = false;
      #  root = "/mount/Data/Datein/Server/startpage/index.html";
      #};

        "nextcloud.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #locations."/" = {
          #  proxyPass = "http://localhost:8080";
          #};
        };

        "vaultwarden.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #locations."/" = {
          #  proxyPass = "http://localhost:8222";
          #};
        };

        "dav.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9123";
          };
        };

        "radicale.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5232/";
            extraConfig = ''
              proxy_set_header  X-Script-Name /;
              proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_pass_header Authorization;
            '';
          };
        };

        "searxng.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8888";
          };
        };

        "invidious.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3000";
          };
        };

        "libreddit.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8975";
          };
        };

        "nzbget.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:6789";
          };
        };

        "nzbhydra2.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5076";
          };
        };

        "radarr.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:7878";
          };
        };

        "sonarr.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8989";
          };
        };

        "lidarr.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8686";
          };
        };

        "readarr.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8787";
          };
        };

        "homeassistant.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8123";
            proxyWebsockets = true;
          };
        };

        "freshrss.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
        };

        "firefoxsync.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5000";
          };
        };

        "nitter.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8970";
          };
        };

        "jellyfin.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8096";
          };
        };

        "pufferpanel.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9090";
          };
        };

        "pufferpanel-sftp.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5657";
          };
        };

        "uptime-kuma.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8765";
          };
        };

        "etesync.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8002";
          };
        };

        "monero.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:18081";
          };
        };

        "adguard.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3333";
          };
        };

        "gitea.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3005";
          };
        };

        "onlyoffice.bitsync.icu" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #listen = [ { addr = "127.0.0.1"; port = 8000; } ];
          #locations."/" = {
          #  proxyPass = "http://localhost:8000";
          #};
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      preliminarySelfsigned = true;
      defaults = {
        dnsResolver = "9.9.9.9";
        email = "among_clavicle129@slmail.me";
        dnsProvider = "ionos";
        dnsPropagationCheck = true;
        renewInterval = "daily";
        environmentFile = config.sops.secrets."nginx/acme/api_key".path;
      };
    };
  };
}
