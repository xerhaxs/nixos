{ config, pkgs, ... }:

{
  imports = [
    ./dunst.nix
    ./hyprland.nix
    ./waybar.nix
    ./wofi.nix
  ];

  home.packages = with pkgs; [
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    papirus-folders
  ];
}
