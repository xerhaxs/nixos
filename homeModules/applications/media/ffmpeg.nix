{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.media.ffmpeg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable ffmpeg.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.ffmpeg.enable {
    home.packages = with pkgs; [
      ffmpeg
    ];
  };
}


