{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./clementine.nix
    ./easyeffects.nix
    ./ffmpeg.nix
    ./freetube.nix
    ./gwenview.nix
    ./mpv.nix
    ./obs-studio.nix
    ./vlc.nix
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
      clementine.enable = true;
      easyeffects.enable = true;
      ffmpeg.enable = true;
      freetube.enable = true;
      gwenview.enable = true;
      mpv.enable = true;
      obs-studio.enable = true;
      vlc.enable = true;
      yt-dlp.enable = true;
    };
  };
}
