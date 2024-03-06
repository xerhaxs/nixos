{ config, pkgs, ... }:

{
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
}
