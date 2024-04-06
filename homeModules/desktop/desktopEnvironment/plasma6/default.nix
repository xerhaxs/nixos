{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.plasma6 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable plasma6 modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.plasma6.enable && osConfig.nixos.desktop.desktopEnvironment.plasma6.enable) {
    imports = [
      ./plasma6.nix
    ];
  };
}