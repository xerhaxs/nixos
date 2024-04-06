{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./audio.nix
      ./clients.nix
      ./ffmpeg.nix
      ./mediaplayer.nix
      ./obs-studio.nix
    ];
  };
}