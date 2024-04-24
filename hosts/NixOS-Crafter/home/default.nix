{ config, lib, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./hyprland.nix
    ./xdg.nix
  ];
}
