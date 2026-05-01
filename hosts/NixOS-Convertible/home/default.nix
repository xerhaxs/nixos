{ config, pkgs, ... }:

{
  imports = [
    ./convertible.nix
    ./home.nix
    ./hyprland.nix
    ./persistent.nix
    ./xdg.nix
  ];
}
