{ config, lib, pkgs, plasma-manager, ... }:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  homeManager.applications.enable = true;

  programs.plasma = {
    workspace = {
      wallpaper = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/54644815047_f6aaedf588_o.jpg";
    };
  };
}