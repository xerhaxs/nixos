{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    framework-tool
  ];
}