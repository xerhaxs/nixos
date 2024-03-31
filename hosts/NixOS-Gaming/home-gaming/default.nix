{ config, pkgs, ... }:

{
  imports = [
    ../../../home

    ../../../home-modules/flameshot.nix
    ../../../home-modules/flatpak.nix
    ../../../home-modules/gaming.nix
    ../../../home-modules/kdeconnect.nix
    ../../../home-modules/librewolf.nix
    ../../../home-modules/multimedia.nix
    ../../../home-modules/syncthing.nix
    ../../../home-modules/theme-mocha.nix

    ./xdg.nix
  ];
}
