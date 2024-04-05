{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    #inkscape-with-extensions
    #krita
    metapixel
  ];
}