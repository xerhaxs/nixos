{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fluent-reader
    ffmpeg
    freetube
    #nuclear
    vlc
    mpv
    clementine
    mediathekview
  ];
}


