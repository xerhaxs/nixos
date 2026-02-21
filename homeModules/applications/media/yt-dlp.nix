{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.media.yt-dlp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable yt-dlp.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
      #settings = { };
    };
  };
}
