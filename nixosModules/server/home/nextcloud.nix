{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.nextcloud = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Nextcloud.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.nextcloud.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      home = "/var/lib/nextcloud";
      hostName = "nextcloud.bitsync.icu";
      https = true;
      extraAppsEnable = true;
      autoUpdateApps.enable = true;
      enableImagemagick = true;
      configureRedis = true;
      maxUploadSize = "8192M";

      config = {
      #  dbtype = "pgsql";
      #  dbuser = "nextcloud";
      #  dbhost = "${config.services.nextcloud.home}/run/postgresql";
      #  dbname = "nextcloud";
      #  dbpassFile = config.sops.secrets."nextcloud/users/admin/password".path;
        adminuser = "admin";
        adminpassFile = config.sops.secrets."nextcloud/users/admin/password".path;  
      };
    
      settings = {
        overwriteprotocol = "https";
        default_phone_region = "DE";
        trusted_domains = [ "10.75.0.1/24" "10.75.0.80" ];
        "profile.enabled" = true;
      };
    };

    #services.postgresql = {
    #  enable = true;
    #  ensureDatabases = [ "nextcloud" ];
    #  ensureUsers = [ {
    #    name = "nextcloud";
    #    ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
    #  } ];
    #};

    #systemd.services."nextcloud-setup" = {
    #  requires = ["postgresql.service"];
    #  after = ["postgresql.service"];
    #};
  };
}

