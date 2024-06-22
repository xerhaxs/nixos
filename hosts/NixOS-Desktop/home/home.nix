{ config, lib, pkgs, ... }:

{
  homeManager.applications.enable = lib.mkForce true;

  #homeManager.desktop.windowManager.hyprland.dunst.enable = lib.mkForce false;
}