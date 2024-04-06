{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.plasma5 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable plasma5 modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.plasma5.enable && osConfig.nixos.desktop.desktopEnvironment.plasma5.enable) {
    imports = [
      ./plasma5.nix
    ];
  };
}