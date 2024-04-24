{ config, lib, pkgs, ... }:

{
  services.freshrss.dataDir = lib.mkDefault "/mount/Data/Datein/Server/freshrss";

  services.webdav.settings = {
    scope = lib.mkDefault "/mount/Data/Datein/Server/webdav/public";
    users = [{ 
      scope = lib.mkDefault "/mount/Data/Datein/Server/webdav/private/admin";
    }];
  };

  services.etebase-server.settings.global.dataDir = lib.mkDefault "/mount/Data/Datein/Server/etesync";

  services.nextcloud.home = lib.mkDefault "/mount/Data/Datein/Server/nextcloud";

  services.radicale.settings.storage.filesystem_folder = lib.mkDefault "/mount/Data/Datein/Server/radicale";

  services.nzbget.settings.MainDir = lib.mkDefault "/mount/Data/Datein/Downloads/NZB Download/";
}