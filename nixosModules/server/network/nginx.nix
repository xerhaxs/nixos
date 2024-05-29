{ config, lib, pkgs, ... }:

let
  domain = "m4rx.cc";
in

{
  options.nixos = {
    server.network.nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
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
      #"${domain}" = {
      #  forceSSL = true;
      #  enableACME = true;
      #  acmeRoot = null;
      #  kTLS = true;
      #  http2 = false;
      #  root = "/mount/Data/Datein/Server/startpage/index.html";
      #};

        "nextcloud.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #locations."/" = {
          #  proxyPass = "http://localhost:8080";
          #};
        };

        "vaultwarden.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #locations."/" = {
          #  proxyPass = "http://localhost:8222";
          #};
        };

        "dav.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9123";
          };
        };

        "radicale.${domain}" = {
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

        "searxng.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8888";
          };
        };

        "invidious.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3000";
          };
        };

        "libreddit.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8975";
          };
        };

        "nzbget.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:6789";
          };
        };

        "nzbhydra2.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5076";
          };
        };

        "radarr.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:7878";
          };
        };

        "sonarr.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8989";
          };
        };

        "lidarr.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8686";
          };
        };

        "readarr.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8787";
          };
        };

        "homeassistant.${domain}" = {
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

        "freshrss.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
        };

        "firefoxsync.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5000";
          };
        };

        "nitter.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8970";
          };
        };

        "jellyfin.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8096";
          };
        };

        "pufferpanel.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9090";
          };
        };

        "pufferpanel-sftp.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5657";
          };
        };

        "uptime-kuma.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8765";
          };
        };

        "etesync.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8002";
          };
        };

        "monero.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:18081";
          };
        };

        "adguard.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3333";
          };
        };

        "gitea.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3005";
          };
        };

        "onlyoffice.${domain}" = {
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

        "murmur.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:64738";
          };
        };
        
        "teamspeak.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:10011";
          };
        };

        "peertube.${domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9000";
          };
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      preliminarySelfsigned = true;
      defaults = {
        dnsResolver = "9.9.9.9";
        email = "among_clavicle129@slmail.me";
        dnsProvider = "cloudflare";
        dnsPropagationCheck = true;
        renewInterval = "daily";
        environmentFile = config.sops.secrets."nginx/acme/api_key".path;
      };
    };
  };
}
