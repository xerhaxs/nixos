{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-community
    jetbrains.pycharm-community
  ];
}
