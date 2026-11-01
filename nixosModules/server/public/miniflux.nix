{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostname = "rss.${config.nixos.server.network.nginx.domain}";
  port = 8085;
in

{
  options.nixos = {
    server.public.miniflux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable the Miniflux RSS reader.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.public.miniflux.enable {
    services.miniflux = {
      enable = true;
      createDatabaseLocally = true;
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString port}";
        BASE_URL = "https://${hostname}";
        CREATE_ADMIN = 0;
        CLEANUP_ARCHIVE_UNREAD_DAYS = 180;
        CLEANUP_ARCHIVE_READ_DAYS = 60;
        POLLING_FREQUENCY = 30;
        FETCH_YOUTUBE_WATCH_TIME = 0;
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
            proxyPass = "http://127.0.0.1:${toString port}";
          };
        };
      };
    };
  };
}
