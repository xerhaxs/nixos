{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.xfce.xfce = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable xfce.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.desktopEnvironment.xfce.xfce.enable {
    #xfconf.settings = { };
  };
}