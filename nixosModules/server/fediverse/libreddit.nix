{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.libreddit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Libreddit.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.libreddit.enable {
    services.redlib = {
      enable = true;
      address = "127.0.0.1";
      port = 8975;
      openFirewall = false;
      settings = {
        REDLIB_DEFAULT_SHOW_NSFW = "on";
        
      };
    };

    services.nginx = {
      virtualHosts = {
        "libreddit.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8975";
          };
        };
      };
    };

    services.ddclient.domains = [
      "libreddit.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
