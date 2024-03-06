{ config, pkgs, ... }:

{
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
          #secret_file = "/mount/Data/Datein/Server/serversecrets/etesync";
          name = "etebase";
          user = "etebase";
          password = "CHANGEME";
          secret_file = "config.sops.secrets."etesync/secret".path";
          static_root = "/mount/Data/Datein/Server/etesync/static/";
          media_root = "/mount/Data/Datein/Server/etesync/";
          language_code = "en-us";
          time_zone = "Europe/Berlin";
      };
    };
  };
}
