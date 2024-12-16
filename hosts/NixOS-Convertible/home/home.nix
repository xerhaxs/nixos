{ config, lib, pkgs, ... }:

{
  homeManager.applications.enable = lib.mkForce true;
  homeManager.desktop.desktopEnvironment.enable = lib.mkForce false;
  homeManager.desktop.windowManager.enable = lib.mkForce false;
}