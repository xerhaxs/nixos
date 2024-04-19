{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./hyprland.nix
    ./xdg.nix
  ];
}
