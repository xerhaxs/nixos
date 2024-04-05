{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    xorg.xkill
  ];

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 100;
  };
}
