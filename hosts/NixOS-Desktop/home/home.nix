{ config, lib, pkgs, plasma-manager, ... }:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  homeManager.applications.enable = lib.mkForce true;

  #homeManager.desktop.windowManager.hyprland.dunst.enable = lib.mkForce false;
  programs.plasma = {
    workspace = {
      wallpaper = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/52338778943_9704c200b4_o.jpg";
    };
  };
}