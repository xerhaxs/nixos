{
  config,
  lib,
  pkgs,
  ...
}:

{
  homeManager.desktop.windowManager.hyprland.wallpaper.directory =
    "${config.xdg.userDirs.pictures}/Desktopbilder/Kanada";

  services.kanshi.settings = [
    {
      profile.name = "desktop";
      profile.outputs = [
        {
          criteria = "DP-1";
          mode = "3840x1600@144";
          position = "0,0";
          scale = 1.0;
          adaptiveSync = true;
        }
      ];
    }
  ];
}
