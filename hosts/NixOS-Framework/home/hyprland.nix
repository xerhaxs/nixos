{
  config,
  lib,
  pkgs,
  ...
}:

{
  homeManager.desktop.windowManager.hyprland.wallpaper.directory =
    "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress";

  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "2256x1504@60";
          position = "0,0";
          scale = 1.25;
        }
      ];
    }
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "2256x1504@60";
          position = "0,0";
          scale = 1.25;
        }
        {
          criteria = "*";
          position = "1805,0";
        }
      ];
    }
  ];
}
