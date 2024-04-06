{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable desktop modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.desktop.enable {
    imports = [
      ./desktopEnvironment
      ./windowManager
      ./xdg.nix
      ./xserver.nix
    ];
  };
}