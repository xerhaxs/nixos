{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./awesome.nix
  ];

  options.homeManager = {
    desktop.windowManager.awesome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable awesome modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.windowManager.awesome.enable && osConfig.nixos.desktop.windowManager.awesome.enable) {
    homeManager.desktop.windowManager.awesome = {
      awesome.enable = true;
    };
  };
}