{ config, lib, pkgs, plasma-manager, ... }:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  homeManager.applications.enable = true;

  homeManager.applications.development.diff.enable = true; # ONLY FOR TESTING PURPOSE OF lib.mkDefault 
  #homeManager.desktop.windowManager.hyprland.dunst.enable = lib.mkForce false;
  
  programs.plasma = {
    workspace = {
      wallpaper = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/52338778943_9704c200b4_o.jpg";
    };
  };
}