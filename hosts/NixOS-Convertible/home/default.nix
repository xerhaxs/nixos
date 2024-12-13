{ config, pkgs, ... }:

{
  imports = [
    ./convertible.nix
    ./home.nix
    ./hyprland.nix
    ./xdg.nix
  ];
}
