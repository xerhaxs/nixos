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
