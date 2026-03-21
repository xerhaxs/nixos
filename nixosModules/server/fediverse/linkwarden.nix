{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.linkwarden = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable linkwarden server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.linkwarden.enable {
    services.linkwarden = {
      enable = true;
      host = "127.0.0.1";
      port = 2794;
      openFirewall = false;
      enableRegistration = false;
      user = "linkwarden";
      group = "linkwarden";
      secretFiles = {
        NEXTAUTH_SECRET = config.sops.secrets."linkwarden/secret".path;
        POSTGRES_PASSWORD = config.sops.secrets."linkwarden/postgres".path;
      }; 
      storageLocation = "/pool01/applications/linkwarden";

      database = {
        name = "linkwarden";
        user = "linkwarden";
        createLocally = true;
      };
    };

    services.postgresql = {
      dataDir = "/pool01/applications/postgresql";
    };

    users = {
      users.linkwarden.uid = 970;
      groups.linkwarden.gid = 970;

      users.postgresql.uid = 971;
      groups.postgresql.gid = 971;
    };

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
