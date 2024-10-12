{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.network.ddclient.enable = true;

  nixos.server.game.enable = true;

  services.ddclient.domains = [
    "flolserver.${config.nixos.server.network.nginx.domain}"
    "creativeserver.${config.nixos.server.network.nginx.domain}"
    "pvpserver.${config.nixos.server.network.nginx.domain}"
    "testserver.${config.nixos.server.network.nginx.domain}"
    "silverageserver.${config.nixos.server.network.nginx.domain}"
  ];
}