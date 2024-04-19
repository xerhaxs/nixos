{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./clients.nix
    ./ffmpeg.nix
    ./mediaplayer.nix
    ./obs-studio.nix
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
      obs-studio.enable = true;
    };
  };
}