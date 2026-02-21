{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.moneronode = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable moneronode.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.moneronode.enable {
    services.monero = {
      enable = true;
      dataDir = "/var/lib/moneronode";

      rpc = {
        user = "admin";
        password = "CHANGEME";
        restricted = false;
        address = "monero.bitsync.icu";
        port = 18081;
      };

      mining = {
        enable = true;
        address = "8ABTHBP7Cbu3X3h7UTLH7Ubk2ELnL4KHr4CzXHVh8WGwjLV92P6sjGQPtKGbRwAaocegiyC8RWzb2BnAAY2n7BcsRSujdvp";
        threads = 2;
      };

      limits = {
        upload = 1000;
        download = 8000;
        threads = 2;
      };
    };

    services.nginx = {
      virtualHosts = {
        "monero.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:18081";
          };
        };
      };
    };

    services.ddclient.domains = [
      "monero.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
