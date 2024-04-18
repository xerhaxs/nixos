{ config, lib, pkgs, ... }:

{
  imports = [
    ./awesome.nix
    ./hyprland.nix
  ];

  options.nixos = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.windowManager.enable {
    nixos.desktop.windowManager = {
      awesome.enable = false;
      hyprland.enable = false;
    };
  };
}
