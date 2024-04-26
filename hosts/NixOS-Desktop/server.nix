{ config, lib, pkgs, ... }:

{
  services.freshrss.dataDir = lib.mkForce "/mount/Data/Datein/Server/freshrss";

  services.webdav.settings = {
    scope = lib.mkForce "/mount/Data/Datein/Server/webdav/public";
    users = [{ 
      scope = lib.mkForce "/mount/Data/Datein/Server/webdav/private/admin";
    }];
  };

  services.etebase-server.settings.global.dataDir = lib.mkForce "/mount/Data/Datein/Server/etesync";

  services.nextcloud.home = lib.mkForce "/mount/Data/Datein/Server/nextcloud";

  services.radicale.settings.storage.filesystem_folder = lib.mkForce "/mount/Data/Datein/Server/radicale";

  services.nzbget.settings.MainDir = lib.mkForce "/mount/Data/Datein/Downloads/NZB Download/";

  nixos.server = {
    home.mailserver.enable = lib.mkForce false;
    fediverse = {
      peertube.enable = lib.mkForce false;
    };
    network.wireguard-server = lib.mkForce false;
  };
}