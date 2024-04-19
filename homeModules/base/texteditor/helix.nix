{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.texteditor.helix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable helix.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.texteditor.helix.enable {
    programs.helix = {
      enable = true;
      #settings = { };
      #languages = { };
      #themes = { };
    };
  };
}