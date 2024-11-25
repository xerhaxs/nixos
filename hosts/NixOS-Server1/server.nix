{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  #nixos.server.enable = lib.mkDefault true;

  nixos.server.usenet.enable = false;

  nixos.server = {
    home = {
      collabora.enable = true;
      firefoxsync.enable = true;
      jellyfin.enable = true;
      nextcloud.enable = true;
      #mailserver.enable = lib.mkForce false;
      #etesync.enable = lib.mkForce false;
      #haos.enable = lib.mkForce false;
      #homeassistant.enable = lib.mkForce false;
    };
    network = {
      #adguard.enable = lib.mkForce false;
    };
    fediverse = {
      freshrss.enable = true;
      gitea.enable = true;
      invidious.enable = true;
    };
  };
}