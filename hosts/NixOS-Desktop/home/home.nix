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
      wallpaperSlideShow = lib.mkForce {
        path = "${config.xdg.userDirs.pictures}/Desktopbilder/Kanada";
        interval = 600;
      };
    };
  };

  homeManager.applications = {
    enable = true;
    development = {
      bottles.enable = true;
      hex.enable = true;
    };
    editing = {
      "3dprinting".enable = true;
      fusion360.enable = true;
    };
    tools.backintime.enable = true;
  };
}
