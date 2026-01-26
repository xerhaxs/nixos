{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.languagetool = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable languagetool.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.languagetool.enable {
    services.languagetool = {
      enable = true;
      port = 8001;
      public = false;
      settings = {
        cacheSize = 1000;
      };
      jvmOptions [
        "-Xmx512m"
      ];
    };

    services.nginx = {
      virtualHosts = {
        "languagetool.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8001";
          };
        };
      };
    };
  }; 
}
