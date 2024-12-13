{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    #kdePackages.kamoso
  ];
}