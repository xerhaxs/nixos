{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.windowManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable windowManager modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.windowManager.enable {
    imports = [
      ./awesome.nix
      ./hyprland.nix
    ];
  };
}
