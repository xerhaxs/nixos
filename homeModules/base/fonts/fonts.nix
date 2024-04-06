{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.fonts.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable fonts config.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.fonts.fonts.enable {
    fonts.fontconfig.enable = true;
  };
}

