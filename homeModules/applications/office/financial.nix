{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    kmymoney
    monero-gui
  ];
}
