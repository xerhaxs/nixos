{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.network.ddclient.enable = true;

  nixos.server.game.enable = true;

  nixos.system.nasmount.enable = lib.mkForce false;
}