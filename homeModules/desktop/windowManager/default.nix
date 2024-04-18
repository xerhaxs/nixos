{ config, lib, pkgs, ... }:

{
  imports = [
    ./awesome
    ./hyprland
  ];

  options.homeManager = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.enable {
    homeManager.desktop.windowManager = {
      awesome.enable = false;
      hyprland.enable = false;
    };
  };
}