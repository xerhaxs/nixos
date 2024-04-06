{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.windowManager.enable {
    imports = [
      ./awesome
      ./hyprland
    ];
  };
}