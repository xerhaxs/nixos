{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    userEnvironment.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fonts config.";
      };
    };
  };

  config = lib.mkIf config.homeManager.userEnvironment.fonts.enable {
    fonts.fontconfig.enable = true;

    gtk.font = {
      name = "Noto Sans";
      package = pkgs.dejavu_fonts;
      size = 10;
    };
  };
}

