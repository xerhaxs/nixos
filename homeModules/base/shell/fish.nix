{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.shell.fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fish.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.fish.enable {
    programs.fish = {
      enable = true;
      catppuccin.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
    };
  };
}
