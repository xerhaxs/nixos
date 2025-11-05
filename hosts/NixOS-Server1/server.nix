{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server = {
    home = {
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