{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.firefoxsync = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Firefoxsync.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.firefoxsync.enable {
    systemd.services.firefox-syncserver.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."firefoxsync/secret".path
    ];

    services.mysql.package = pkgs.mariadb;

    services.firefox-syncserver = {
      enable = true;
      secrets = config.sops.secrets."firefoxsync/secret".path;
      singleNode = {
        enable = true;
        hostname = "localhost";
        url = "http://localhost:5000";
      };
    };

    services.nginx = {
      virtualHosts = {
        "firefoxsync.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:5000";
          };
        };
      };
    };
  };
}
