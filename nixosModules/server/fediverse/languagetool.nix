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
      jvmOptions = [
        "-Xmx512m"
      ];
    };

    # Working API Domain: https://languagetool.${config.nixos.server.network.nginx.domain}/v2/

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
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Content-Type "application/x-www-form-urlencoded";
            '';
          };
        };
      };
    };
  }; 
}
