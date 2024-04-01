{ config, lib, pkgs, ... }:

{
  imports = [
    ./cinnamon.nix
    ./gnome.nix
    ./plasma5-bigscreen.nix
    ./plasma5.nix
    ./plasma6.nix
    ./xfce.nix
  ];
}
