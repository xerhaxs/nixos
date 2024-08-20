{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.sonarr = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Sonarr.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = false;
      #dataDir = "";
    };

    services.nginx = {
      virtualHosts = {
        "sonarr.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8989";
          };
        };
      };
    };
  };
}
