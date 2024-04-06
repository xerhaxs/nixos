{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.enable {
    imports = [
      ./gnome
      ./plasma5
      ./plasma6
      ./xfce
    ];
  };
}