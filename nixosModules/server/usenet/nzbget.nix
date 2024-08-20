{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.usenet.nzbget = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable NZBGet.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.usenet.nzbget.enable {
    services.nzbget = {
      enable = true;
      settings = {
        MainDir = "/var/lib/nzbget/download";
        ControlPort = "6789";
        #ControlUsername = "admin";
        #ControlPassword = "CHANGEME";
      };
    };

    services.nginx = {
      virtualHosts = {
        "nzbget.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:6789";
          };
        };
      };
    };
  };
}
