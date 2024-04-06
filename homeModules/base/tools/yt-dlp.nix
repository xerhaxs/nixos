{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.yt-dlp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable yt-dlp.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
      #settings = { };
    };
  };
}
