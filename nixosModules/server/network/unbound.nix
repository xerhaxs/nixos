{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.network.unbound = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable unbound.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.unbound.enable {
    services.unbound = {
      enable = true;
      user = "unbound";
      group = "unbound";
      stateDir = "/var/lib/unbound";
      enableRootTrustAnchor = true;
      resolveLocalQueries = true;

      settings = {
        server = {
          interface = [ "127.0.0.1" ];
          port = [ "5335" ];
          access-control = [ "127.0.0.1 allow" ];

          do-ip4 = true;
          do-ip6 = true;
          prefer-ip4 = true;
          prefer-ip6 = false;
          do-udp = true;
          do-tcp = true;

          harden-glue = true;
          harden-dnssec-stripped = true;
          harden-below-nxdomain = true;
          harden-algo-downgrade = true;
          qname-minimisation = true;
          aggressive-nsec = true;
          val-clean-additional = true;
          prefetch-key = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;

          # Query types, rcodes, DNSSEC and memory for the exporter and its dashboard.
          extended-statistics = true;

          hide-identity = true;
          hide-version = true;
          num-threads = 1;
          so-rcvbuf = "1m";

          private-address = [
            "192.168.0.0/16"
            "169.254.0.0/16"
            "172.16.0.0/12"
            "10.0.0.0/8"
            "fd00::/8"
            "fe80::/10"
            "192.0.2.0/24"
            "198.51.100.0/24"
            "203.0.113.0/24"
            "255.255.255.255/32"
            "2001:db8::/32"
          ];
        };

        # Mullvad rejects port 53 to every address except its custom DNS 127.0.0.1, also inside the
        # tunnel, so recursion to the root servers fails. Forward over TLS (port 853) through the tunnel.
        forward-zone = lib.mkIf config.nixos.server.network.mullvad-server.enable [
          {
            name = ".";
            forward-tls-upstream = true;
            forward-addr = [
              "194.242.2.2@853#dns.mullvad.net"
              "2a07:e340::2@853#dns.mullvad.net"
            ];
          }
        ];
      };
    };

    environment.persistence."/persistent" = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        "/var/lib/unbound"
      ];
    };
  };
}
