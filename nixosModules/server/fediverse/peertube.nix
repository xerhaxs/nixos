{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.peertube = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Peertube.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.peertube.enable {
    services.peertube = {
      enable = true;
      user = "peertube";
      group = "peertube";
      enableWebHttps = true;
      localDomain = "localhost";
      listenHttp = 9000;
      listenWeb = 443;
      #dataDirs [
      #  "/opt/peertube/storage"
      #  "/var/cache/peertube"
      #];

      secrets.secretsFile = config.sops.secrets."peertube/secret".path;
      smtp.passwordFile = config.sops.secrets."peertube/smtppassword".path;
      serviceEnvironmentFile = config.sops.secrets."peertube/password".path;

      settings = {
        listen = {
          hostname = "0.0.0.0";
        };
        log = {
          level = "debug";
        };
      };

      redis = {
        createLocally = true;
      };
    };

    services.nginx = {
      virtualHosts = {
        "peertube.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:9000";
          };
        };
      };
    };

    services.ddclient.domains = [
      "peertube.${config.nixos.server.network.nginx.domain}"
    ];
  };
}
