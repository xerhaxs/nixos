{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.windowManager.awesome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable awesome modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.windowManager.awesome.enable && osConfig.nixos.desktop.windowManager.awesome.enable) {
    imports = [
      ./awesome.nix
    ];
  };
}