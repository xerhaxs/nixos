{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.radarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Radarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };

    services.nginx = {
      virtualHosts = {
        "radarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:7878";
          };
        };
      };
    };

    services.ddclient.domains = [
      "radarr.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
