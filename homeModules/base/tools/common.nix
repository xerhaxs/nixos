{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.tools.common = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable common tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.tools.common.enable {
    home.packages = with pkgs; [
      qalculate-gtk
      gnome-disk-utility
    ];
  };
}
