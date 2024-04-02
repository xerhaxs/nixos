{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.windowManager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.desktop.windowManager.enable {
    imports = [
      ./awesome.nix
      ./hyprland.nix
    ];
  };
}
