{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.mastodon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Mastodon.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.mastodon.enable {
    services.mastodon = {
      enable = true;
      localDomain = "mastodon.${config.nixos.server.network.nginx.domain}";
      webPort = 55001;
      streamingProcesses = 8;
    };

    services.nginx = {
      virtualHosts = {
        "mastodon.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:55001";
          };
        };
      };
    };

    services.ddclient.domains = [
      "mastodon.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
