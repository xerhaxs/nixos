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
          user = "admin";
          lists = [
            {
              url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
            }
          ];
          privacyLevel = 0;
          #settings = {};
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
