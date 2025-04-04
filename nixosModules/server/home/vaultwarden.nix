{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.vaultwarden = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Vaultwarden.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      config = {
        DOMAIN = "vaultwarden.bitsync.icu";
        SIGNUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;

        ROCKET_LOG = "critical";
      };
    };

    services.nginx = {
      virtualHosts = {
        "vaultwarden.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          #locations."/" = {
          #  proxyPass = "http://localhost:8222";
          #};
        };
      };
    };

    services.ddclient.domains = [
      "vaultwarden.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
