{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome
    #./plasma5
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
      gnome.enable = true;
      #plasma5.enable = true;
      plasma6.enable = true;
      xfce.enable = true;
    };
  };
}