{
  config,
  lib,
  pkgs,
  plasma-manager,
  ...
}:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    workspace = {
      wallpaper = lib.mkForce "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/52338778943_9704c200b4_o.jpg";
    };
  };

  homeManager.applications.enable = true;
}
