{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  imports = [
    ./display.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./pyprland.nix
    ./rofi.nix
    ./swaync.nix
    ./touch.nix
    ./utilities.nix
    ./wallpaper.nix
    ./waybar.nix
    ./widgets.nix
    ./wlogout.nix
  ];

  options.homeManager = {
    desktop.windowManager.hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hyprland modules bundle.";
      };
    };
  };

  config =
    lib.mkIf
      (
        config.homeManager.desktop.windowManager.hyprland.enable
        && osConfig.nixos.desktop.windowManager.hyprland.enable
      )
      {
        homeManager.desktop.windowManager.hyprland = {
          display.enable = true;
          hypridle.enable = true;
          hyprland.enable = true;
          hyprlock.enable = true;
          pyprland.enable = true;
          rofi.enable = true;
          swaync.enable = true;
          touch.enable = lib.mkDefault false;
          utilities.enable = true;
          wallpaper.enable = true;
          waybar.enable = true;
          widgets.enable = true;
          wlogout.enable = true;
        };
      };
}
