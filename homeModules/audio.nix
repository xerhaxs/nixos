{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    easyeffects
    helvum
    pavucontrol
  ];
}