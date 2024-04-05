{ config, lib, pkgs, ... }:

{
  programs.yt-dlp = {
    enable = true;
    #settings = { };
  };
}
