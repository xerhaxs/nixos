{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.tools.btop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable btop.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.btop.enable {
    programs.btop = {
      enable = true;
      #settings = {};
    };

    catppuccin.btop.enable = lib.mkIf config.homeManager.theme.catppuccin.enable true;
  };
}
