{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.freshrss = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Freshrss.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.freshrss.enable {
    systemd.services.freshrss-config.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."freshrss/users/defaultUser/password".path
    ];

    services.freshrss = {
      enable = true;  
      defaultUser = "admin";
      passwordFile = config.sops.secrets."freshrss/users/defaultUser/password".path;
      language = "de";
      dataDir = "/var/lib/freshrss";
      baseUrl = "http://freshrss.${config.nixos.server.network.nginx.domain}";
      virtualHost = "freshrss";
      database = {
        type = "sqlite";
        port = 3306;
        host = "localhost";
        name = "freshrss";
        user = "freshrss";
      };
    };

    services.nginx = {
      virtualHosts = {
        "freshrss.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:3306/";
          };
        };
      };
    };

    services.ddclient.domains = [
      "freshrss.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
