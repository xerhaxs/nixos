{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.fediverse.freshrss = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Freshrss.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.freshrss.enable {
    systemd.services.freshrss-config.serviceConfig.EnvironmentFile = [ 
      config.sops.secrets."freshrss/users/defaultUser/password".path
    ];

    services.freshrss = {
      enable = true;  
      defaultUser = "admin";
      passwordFile = config.sops.secrets."freshrss/users/defaultUser/password".path;
      language = "de";
      dataDir = "/mount/Data/Datein/Server/freshrss";
      baseUrl = "https://freshrss.bitsync.icu";
      virtualHost = "freshrss.bitsync.icu";
      database = {
        type = "sqlite";
        port = 3306;
        host = "localhost";
        name = "freshrss";
        user = "freshrss";
      };
    };
  };
}
