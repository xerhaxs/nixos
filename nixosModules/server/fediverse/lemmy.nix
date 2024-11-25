{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.lemmy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Lemmy.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.lemmy.enable {
    services.lemmy = {
      enable = true;
      adminPasswordFile = config.sops.secrets."lemmy/users/admin/password".path;
      ui = {
        port = 8537;
      };
      settings = {
        hostname = "lemmy.m4rx.cc";
        port = 8536;
        captcha.enabled = false;
      };
    };

    services.nginx = {
      virtualHosts = {
        "lemmy.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:8537";
          };
        };
      };
    };

    services.ddclient.domains = [
      "lemmy.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
