{ config, pkgs, ... }:

{
  imports = [
    ../../../home

    ../../../home-modules/3dprinting.nix
    ../../../home-modules/applications.nix
    ../../../home-modules/editing.nix
    #../../../home-modules/gnome
    ../../../home-modules/hyprland
    ../../../home-modules/firefox.nix
    ../../../home-modules/flameshot.nix
    ../../../home-modules/flatpak.nix
    ../../../home-modules/hacking.nix
    ../../../home-modules/kdeconnect.nix
    ../../../home-modules/librewolf.nix
    ../../../home-modules/multimedia.nix
    ../../../home-modules/obs-studio.nix
    ../../../home-modules/office.nix
    ../../../home-modules/plasma5.nix
    ../../../home-modules/privacy.nix
    ../../../home-modules/programming.nix
    ../../../home-modules/syncthing.nix
    ../../../home-modules/theme-latte.nix
    #../../../home-modules/thunderbird.nix
    ../../../home-modules/virtualisation.nix
    ../../../home-modules/vscodium.nix

    ./hyprland.nix
    ./xdg.nix
  ];
}
