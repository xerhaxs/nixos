{
  config,
  lib,
  pkgs,
  ...
}:

{
  homeManager.desktop.windowManager.hyprland = {
    touch.enable = true;
    wallpaper.directory = "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress";
  };

  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1280@60";
          position = "0,0";
          scale = 1.0;
        }
      ];
    }
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1280@60";
          position = "0,0";
          scale = 1.0;
        }
        {
          criteria = "*";
          position = "1920,0";
        }
      ];
    }
  ];
}
