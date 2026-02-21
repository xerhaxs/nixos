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
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;

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

        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "9.9.9.9#dns.quad9.net"
              "149.112.112.112#dns.quad9.net"
            ];
            forward-tls-upstream = true;
          }
        ];

        remote-control.control-enable = false;
      };
    };

    environment.persistence."/persistent" = {
      directories = [
        "/var/lib/unbound"
      ];
    };
  };
}
