{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fileshare.webdav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Webdav file share.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fileshare.webdav.enable {
    systemd.services.webdav.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."webdav/users/admin/username".path
      config.sops.secrets."webdav/users/admin/password".path 
    ];

    services.webdav = {
      enable = true;
      settings = {
        address = "127.0.0.1";
        port = 9123;
        scope = "/srv/public";
        modify = true;
        auth = true;
        users = [
          {
            scope = "/srv/private/admin";
            username = "{env}ENV_USERNAME";
            password = "{env}ENV_PASSWORD";
          }
        ];
      };
    };

    services.nginx = {
      virtualHosts = {
        "dav.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9123";
          };
        };
      };
    };

    services.ddclient.domains = [
      "dav.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
