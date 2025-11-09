{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server = {
    fileshare = {
      samba.enable = true
    };
    home = {
      glance.enable = true;
      #jellyfin.enable = true;
      ollama.enable = true;
      #radicale.enable = true;
    };
    network = {
      pihole.enable = lib.mkForce true;
    };
    fediverse = {
      invidious.enable = true;
    };
  };
}