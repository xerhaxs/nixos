{ config, pkgs, ... }:

{
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    tenacity
    gimp
    #krita
    metapixel
    inkscape-with-extensions
    kdenlive
    blender-hip
    vlc
    handbrake
    yt-dlp # A command-line video downloader
    imagemagick
    # AI Tools
    upscayl
    openai-whisper
  ];
}


