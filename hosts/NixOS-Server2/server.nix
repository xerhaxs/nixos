{ config, lib, pkgs, ... }:

{
  nixos.server.enable = false;

  nixos.server.game.enable = true;
}