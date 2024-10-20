{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.network.uptime-kuma = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Uptime Kuma.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.network.uptime-kuma.enable {
    services.uptime-kuma = {
      enable = true;
      appriseSupport = true;
      settings = {
        HOST = "uptime-kuma.bitsync.icu";
        PORT = "8765";
      };
    };

    services.nginx = {
      virtualHosts = {
        "uptime-kuma.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8765";
          };
        };
        "kuma.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8765";
          };
        };
      };
    };

    services.ddclient.domains = [
      "uptime-kuma.${config.nixos.server.network.nginx.domain}"
      "kuma.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
