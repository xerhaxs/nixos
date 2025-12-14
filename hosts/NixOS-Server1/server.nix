{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server = {
    fediverse = {
      invidious.enable = true;
      libreddit.enable = true;
      nitter.enable = true;
      searxng.enable = true;
    };
    fileshare = {
      samba.enable = false;
    };
    home = {
      glance.enable = true;
      #jellyfin.enable = true;
      ollama.enable = true;
      radicale.enable = true;
    };
    network = {
      pihole.enable = true;
    };
  };
}