{
  config,
  lib,
  pkgs,
  ...
}:

let
  domain = config.nixos.server.network.nginx.domain;
  hostname = "office.${domain}";
in

{
  options.nixos = {
    server.public.collabora = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Collabora Online for Nextcloud Office.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.collabora.enable {
    services.collabora-online = {
      enable = true;
      port = 9980;
      settings = {
        ssl = {
          enable = false;
          termination = true;
        };

        net = {
          listen = "loopback";
          post_allow.host = [
            "127\\.0\\.0\\.1"
            "::1"
          ];
        };

        storage.wopi = {
          "@allow" = true;
          host = [ "cloud.${domain}" ];
        };

        server_name = hostname;
      };
    };

    services.nginx = {
      virtualHosts = {
        "${hostname}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.collabora-online.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 36000s;
            '';
          };
        };
      };
    };
  };
}
