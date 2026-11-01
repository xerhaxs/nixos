{ config, pkgs, ... }:

{
  imports = [
    ../../NixOS-Desktop/home/home.nix
    ./xdg.nix
  ];
}
