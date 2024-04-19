{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./plasma5.nix
  ];

  options.homeManager = {
    desktop.desktopEnvironment.plasma5 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable plasma5 modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.plasma5.enable && osConfig.nixos.desktop.desktopEnvironment.plasma5.enable) {
    homeManager.desktop.desktopEnvironment.plasma5 = {
      plasma5.enable = true;
    };
  };
}