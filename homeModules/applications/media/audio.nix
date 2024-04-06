{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.media.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable audio tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.media.audio.enable {
    home.packages = with pkgs; [
      easyeffects
      #goxlr-utility
      helvum
      #pavucontrol
    ];
  };
}