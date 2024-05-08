{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.fonts.fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable fonts config.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.fonts.fonts.enable {
    fonts.fontconfig.enable = true;

    gtk.font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
      size = 10;
    };
  };
}

