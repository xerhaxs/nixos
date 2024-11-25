{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.pixelfed = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Pixelfed.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.pixelfed.enable {
    services.pixelfed = {
      enable = true;
      domain = "pixelfed.${config.nixos.server.network.nginx.domain}";
      secretFile = config.sops.secrets."pixelfed/password".path;
    };

    services.nginx = {
      virtualHosts = {
        "pixelfed.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9001";
          };
        };
      };
    };

    services.ddclient.domains = [
      "pixelfed.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
