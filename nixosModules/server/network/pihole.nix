{
  config,
  lib,
  pkgs,
  ...
}:

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
    networking.networkmanager.dns = "none";
    networking.resolvconf.enable = false;
    services.resolved.enable = false;

    environment.etc."resolv.conf".text = ''
      nameserver 127.0.0.1
    '';

    # FTLCONF_webserver_api_password (plaintext, FTL computes pwhash) and
    # FTLCONF_webserver_api_app_pwhash (hash). Environment values override pihole.toml.
    sops.secrets."pihole/env" = {
      owner = config.services.pihole-ftl.user;
      restartUnits = [ "pihole-ftl.service" ];
    };

    systemd.services.pihole-ftl.serviceConfig.EnvironmentFile = config.sops.secrets."pihole/env".path;

    services = {
      pihole-ftl = {
        enable = true;
        stateDirectory = "/var/lib/pihole";
        logDirectory = "/var/log/pihole";

        openFirewallDNS = true;
        openFirewallDHCP = false;
        openFirewallWebserver = false;

        lists = [
          {
            url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            type = "block";
            enabled = true;
            description = "StevenBlack";
          }
          {
            url = "https://blocklistproject.github.io/Lists/malware.txt";
            type = "block";
            enabled = true;
            description = "Malware";
          }
          {
            url = "https://blocklistproject.github.io/Lists/phishing.txt";
            type = "block";
            enabled = true;
            description = "Phishing";
          }
          {
            url = "https://blocklistproject.github.io/Lists/ransomware.txt";
            type = "block";
            enabled = true;
            description = "Ransomware";
          }
          {
            url = "https://blocklistproject.github.io/Lists/scam.txt";
            type = "block";
            enabled = true;
            description = "Scam";
          }
          {
            url = "https://blocklistproject.github.io/Lists/tiktok.txt";
            type = "block";
            enabled = true;
            description = "TikTok";
          }
          {
            url = "https://blocklistproject.github.io/Lists/tracking.txt";
            type = "block";
            enabled = true;
            description = "Tracking";
          }
          {
            url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
            type = "block";
            enabled = true;
            description = "Smart-TV";
          }
          {
            url = "https://blocklistproject.github.io/Lists/adobe.txt";
            type = "block";
            enabled = true;
            description = "Adobe";
          }
          {
            url = "https://perflyst.github.io/PiHoleBlocklist/AmazonFireTV.txt";
            type = "block";
            enabled = true;
            description = "AmazonFireTV";
          }
          {
            url = "https://small.oisd.nl";
            type = "block";
            enabled = true;
            description = "OISD Small";
          }
          {
            url = "https://big.oisd.nl";
            type = "block";
            enabled = true;
            description = "OISD Big";
          }
          {
            url = "https://blocklistproject.github.io/Lists/ads.txt";
            type = "block";
            enabled = true;
            description = "Ads";
          }
        ];

        privacyLevel = 0;
        settings = {
          dns = {
            upstreams = [
              "127.0.0.1#5335"
              #"9.9.9.9"
              #"149.112.112.112"
              #"2620:fe::fe"
              #"2620:fe::9"
              #"9.9.9.11"
              #"2620:fe::11"
              #"149.112.112.11"
              #"2620:fe::fe:11"
              #"2606:4700:4700::1001"
              #"2606:4700:4700::1111"
              #"1.0.0.1"
              #"1.1.1.1"
            ];

            CNAMEdeepInspect = true;

            blockESNI = true;

            EDNS0ECS = true;

            ignoreLocalhost = false;

            showDNSSEC = true;

            analyzeOnlyAandAAAA = false;

            piholePTR = "PI.HOLE";

            replyWhenBusy = "BLOCK";

            blockTTL = 2;

            hosts = lib.flatten (
              lib.mapAttrsToList (
                ip: names: map (name: "${ip} ${name}") names
              ) config.nixos.system.networking.lan.hosts
            );

            domainNeeded = false;

            expandHosts = false;

            domain = "pi.hole";

            bogusPriv = true;

            dnssec = true;

            #interface = "eth0";

            hostRecord = "";

            listeningMode = "LOCAL";

            queryLogging = true;

            cnameRecords = [ ];

            #port = 53;

            # "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]"
            revServers = [
              "true,10.75.0.0/24,fritz.box"
            ];

            cache = {
              size = 10000;

              # altogether.
              optimizer = 3600;

              upstreamBlockedTTL = 86400;
            };

            blocking = {
              active = true;

              mode = "NULL";

              edns = "TEXT";
            };

            specialDomains = {
              mozillaCanary = true;

              iCloudPrivateRelay = true;

              designatedResolver = true;
            };

            reply = {
              host = {
                force4 = false;

                IPv4 = "";

                force6 = false;

                IPv6 = "";
              };

              blocking = {
                force4 = false;

                IPv4 = "";

                force6 = false;

                IPv6 = "";
              };
            };

            rateLimit = {
              # FTL.
              # dns.rateLimit.count=1 and dns.rateLimit.interval=3600. The time interval is relative
              count = 10000;

              interval = 60;
            };
          };
          webserver = {
            domain = "localhost";

            acl = "";

            # [...]
            port = "3334";

            threads = 50;

            # [...]
            headers = [
              "X-DNS-Prefetch-Control: off"
              "Content-Security-Policy: default-src 'self' 'unsafe-inline';"
              "X-Frame-Options: DENY"
              "X-XSS-Protection: 0"
              "X-Content-Type-Options: nosniff"
              "Referrer-Policy: strict-origin-when-cross-origin"
            ];

            serve_all = false;

            session = {
              timeout = 1800;

              restore = true;
            };

            #tls = {
            #cert = "/etc/pihole/tls.pem";
            #};

            #paths = {
            #webroot = "/var/www/html";

            #webhome = "/admin/";

            # [...]
            #};

            interface = {
              boxed = true;

              theme = "default-auto";
            };

            api = {
              max_sessions = 16;

              prettyJSON = false;

              totp_secret = "";

              app_sudo = false;

              cli_pw = true;

              # [...]
              excludeClients = [ ];

              excludeDomains = [ ];

              maxHistory = 86400;

              maxClients = 10;

              client_history_global_max = true;

              allow_destructive = true;

              temp = {
                limit = 60.000000;

                unit = "K";
              };
            };
          };
        };
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
          http2 = true;
          locations."/" = {
            proxyPass = "http://localhost:3334";
          };
        };
      };
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/pihole"
      ];
    };
  };
}
