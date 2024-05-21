{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.media.mediaplayer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mediaplayer.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.mediaplayer.enable {
    home.packages = with pkgs; [
      clementine
      vlc
    ];
  };
}


