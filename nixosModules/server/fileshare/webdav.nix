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
      settings = {
        address = "127.0.0.1";
        port = 9123;
        directory = "/srv/public";
        permissions = "R";
        #directory = "${config.nixos.server.fileshare.share.path}/jf";
        #permissions = "R";
        users = [
          {
            username = "jf";
            password = "{env}ENV_PASSWORD";
            #modify = true;
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
  };
}
