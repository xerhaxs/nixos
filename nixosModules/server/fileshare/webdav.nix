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
      config.sops.secrets."webdav-share/user-jf".path
    ];

    services.webdav = {
      enable = true;
      user = "webdav";
      group = "webdav";
      settings = {
        address = "127.0.0.1";
        port = 9123;
        behindProxy = true;
        permissions = "none";
        users = [
          {
            username = "jf";
            password = "{env}ENV_PASSWORD";
            directory = "/srv/share/jf/WebDAV";
            #directory = "${config.nixos.server.fileshare.share.path}/jf/WebDAV";
            permissions = "CRUD";
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

            extraConfig = ''
              client_max_body_size 0;
              proxy_http_version 1.1;

              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;

              proxy_buffering off;
              proxy_request_buffering off;
              proxy_cache off;

              sendfile off;
              aio off;
            '';
          };
        };
      };
    };
  };
}
