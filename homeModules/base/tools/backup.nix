{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    backintime
    grsync
  ];
}
