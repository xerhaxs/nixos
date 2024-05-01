{ config, pkgs, ... }:

{
  imports = [
    ./framework.nix
    ./home.nix
    ./hyprland.nix
    ./xdg.nix
  ];
}
