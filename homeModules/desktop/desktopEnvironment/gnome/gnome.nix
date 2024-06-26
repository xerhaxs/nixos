{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.gnome.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gnome.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.gnome.gnome.enable {
    home.packages = with pkgs; [
      gnome.gnome-disk-utility
      gnome.file-roller
    ];
  };
}

