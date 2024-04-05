{ config, lib, pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    #settigns = { };
  };
}