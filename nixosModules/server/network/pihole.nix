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
