{ config, lib, pkgs, plasma-manager, ... }:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  homeManager.applications.enable = lib.mkForce true;

  programs.plasma = {
    configFile = {
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."Image" = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/54644815047_f6aaedf588_o.jpg";
    };
  };
}