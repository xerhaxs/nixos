{ config, pkgs, ... }:

{
  imports = [
    ../../../home

    ../../../home-modules/hyprland
    ../../../home-modules/firefox.nix
    ../../../home-modules/flameshot.nix
    ../../../home-modules/kdeconnect.nix
    ../../../home-modules/librewolf.nix
    ../../../home-modules/multimedia.nix
    ../../../home-modules/obs-studio.nix
    ../../../home-modules/office.nix
    ../../../home-modules/plasma5.nix
    #../../../home-modules/syncthing.nix
    ../../../home-modules/theme-latte.nix
    #../../../home-modules/thunderbird.nix
    ../../../home-modules/virtualisation.nix
    ../../../home-modules/vscodium.nix

    ./xdg.nix
  ];
}
