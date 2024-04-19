{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.gaming.mangohud = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable mangohud.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      #settigns = { };
    };
  };
}