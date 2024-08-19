{ config, lib, pkgs, ... }:

{
  nixos.server.enable = false;

  services.xserver.displayManager.startx.enable = true;

  nixos.server.game.enable = lib.mkForce true;
}