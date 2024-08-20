{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.nzbhydra2 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable NZBHydra2.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.nzbhydra2.enable {
    services.nzbhydra2 = {
      enable = true;
      openFirewall = false;
    };

    services.nginx = {
      virtualHosts = {
        "nzbhydra2.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5076";
          };
        };
      };
    };    
  };
}

