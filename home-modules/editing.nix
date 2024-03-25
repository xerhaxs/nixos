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
    #handbrake
    #ffmpeg
    #gst_all_1.gst-libav
    yt-dlp # A command-line video downloader
    imagemagick
    # AI Tools
    upscayl
    openai-whisper
  ];
}


