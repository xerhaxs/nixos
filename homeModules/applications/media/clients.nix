{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fluent-reader
    freetube
    mediathekview
    nuclear
    qbittorrent
  ];
}


