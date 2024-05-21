{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.media.mpv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mpv.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.mpv.enable {
    programs.mpv = {
      enable = true;
      catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
      config = {
        profile = "gpu-hq";
        force-window = true;
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };
  };
}


