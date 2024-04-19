{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.editing.image = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable image tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.editing.image.enable {
    home.packages = with pkgs; [
      gimp
      #inkscape-with-extensions
      #krita
      metapixel
    ];
  };
}