{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable audio tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.audio.enable {
    home.packages = with pkgs; [
      tenacity
    ];
  };
}