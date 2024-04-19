{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome
    ./plasma5
    ./plasma6
    ./xfce
  ];

  options.homeManager = {
    desktop.desktopEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.enable {
    homeManager.desktop.desktopEnvironment = {
      gnome.enable = false;
      plasma5.enable = false;
      plasma6.enable = false;
      xfce.enable = false;
    };
  };
}