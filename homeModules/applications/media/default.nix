{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./clients.nix
    ./ffmpeg.nix
    ./mediaplayer.nix
    ./mpv.nix
    ./obs-studio.nix
    ./yt-dlp.nix
  ];

  options.homeManager = {
    applications.media = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable media modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.enable {
    homeManager.applications.media = {
      audio.enable = true;
      clients.enable = true;
      ffmpeg.enable = true;
      mediaplayer.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      yt-dlp.enable = true
    };
  };
}