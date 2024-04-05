{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    easyeffects
    #goxlr-utility
    helvum
    #pavucontrol
  ];
}