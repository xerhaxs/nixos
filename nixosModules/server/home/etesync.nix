{ config, lib, pkgs, ... }:

{
  options.nixos = {
    server.home.etesync = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Etesync.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.home.etesync.enable {
    services.etesync-dav = {
      enable = true;
      openFirewall = false;
      host = "localhost";
      port = 37358;
    };

    services.etebase-server = {
      enable = true;
      port = 8735;
      openFirewall = false;
      
      settings = {
        allowed_hosts.allowed_host1 = "etesync.bitsync.icu";
        global = {
            name = "etebase";
            user = "etebase";
            password = "CHANGEME";
            secret_file = "config.sops.secrets."etesync/secret".path";
            dataDir = "/var/lib/etebase-server";
            static_root = "${config.services.etebase-server.dataDir}/static";
            media_root = "${config.services.etebase-server.dataDir}/media";
            language_code = "en-us";
            time_zone = "Europe/Berlin";
        };
      };
    };
  };
}
