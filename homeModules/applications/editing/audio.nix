{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.audio = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
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