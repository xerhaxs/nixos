{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.shell.starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable starship.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.starship.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      #settings = { };
    };

    catppuccin.starship.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
