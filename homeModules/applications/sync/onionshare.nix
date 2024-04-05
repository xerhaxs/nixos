{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    onionshare-gui
  ];
}

