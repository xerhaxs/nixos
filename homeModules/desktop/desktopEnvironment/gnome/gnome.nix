{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-disk-utility
    gnome.file-roller
  ];
}

