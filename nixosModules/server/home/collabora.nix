{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.collabora = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable collabora.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.collabora.enable {
    services.collabora-online = {
      enable = true;
      port = 9980;
    };

    services.nginx = {
      virtualHosts = {
        "collabora.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9980";
          };
        };
      };
    };

    services.ddclient.domains = [
      "collabora.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
