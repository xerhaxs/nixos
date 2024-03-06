{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ffmpeg
    freetube
    #nuclear
    vlc
    mpv
    clementine
    mediathekview
  ];
}


