{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    clementine
    mpv
    vlc
  ];
}


