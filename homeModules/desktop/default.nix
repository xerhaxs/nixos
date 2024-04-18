{ config, lib, pkgs, ... }:

{
  imports = [
    ./desktopEnvironment
    ./windowManager
    ./xdg.nix
    ./xserver.nix
  ];

  options.homeManager = {
    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable desktop modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.enable {
    homeManager.desktop = {
      desktopEnvironment.enable = true;
      windowManager.enable = true;
      xdg.enable = true;
      xserver.enable = true;
    };
  };
}