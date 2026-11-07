{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.sync.linkwarden = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable linkwarden server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.sync.linkwarden.enable {
    sops.secrets."linkwarden/secret" = {
      owner = config.services.linkwarden.user;
      group = config.services.linkwarden.group;
      mode = "0400";
      restartUnits = [ "linkwarden.service" ];
    };
    sops.secrets."linkwarden/postgres" = {
      owner = config.services.linkwarden.user;
      group = config.services.linkwarden.group;
      mode = "0400";
      restartUnits = [ "linkwarden.service" ];
    };

    services.linkwarden = {
      enable = true;
      host = "127.0.0.1";
      port = 2794;
      openFirewall = false;
      enableRegistration = true;
      user = "linkwarden";
      group = "linkwarden";

      environment = {
        NEXTAUTH_URL = "https://linkwarden.${config.nixos.server.network.nginx.domain}";
      };

      secretFiles = {
        NEXTAUTH_SECRET = config.sops.secrets."linkwarden/secret".path;
        POSTGRES_PASSWORD = config.sops.secrets."linkwarden/postgres".path;
      };

      storageLocation = "${config.nixos.server.dataDir}/linkwarden";

      database = {
        name = "linkwarden";
        user = "linkwarden";
        createLocally = true;
      };
    };

    environment.systemPackages = with pkgs; [
      linkwarden
    ];

    services.nginx = {
      virtualHosts = {
        "linkwarden.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:2794";
          };
        };
      };
    };
  };
}
