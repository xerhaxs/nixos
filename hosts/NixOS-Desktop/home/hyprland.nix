{
  config,
  lib,
  pkgs,
  ...
}:

{
  homeManager.desktop.windowManager.hyprland.wallpaper.directory =
    "${config.xdg.userDirs.pictures}/Desktopbilder/Kanada";

  # No thermal zone on this board, k10temp reports the CPU temperature.
  programs.waybar.settings.mainBar.temperature = {
    hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
    input-filename = "temp1_input";
  };

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
