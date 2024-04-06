{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.video = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable video tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.video.enable {
    home.packages = with pkgs; [
      kdenlive
    ];
  };
}