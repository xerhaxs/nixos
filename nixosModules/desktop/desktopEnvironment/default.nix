{ config, lib, pkgs, ... }:

{
  imports = [
    ./gnome.nix
    ./plasma6.nix
  ];

  options.nixos = {
    desktop.desktopEnvironment = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.enable {
    nixos.desktop.desktopEnvironment = {
      gnome.enable = false;
      plasma6.enable = true;
    };
  };
}
