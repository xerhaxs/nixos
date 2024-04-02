{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.desktopEnvironment = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable desktopEnvironment modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.desktop.desktopEnvironment.enable {
    imports = [
      ./cinnamon.nix
      ./gnome.nix
      ./plasma5-bigscreen.nix
      ./plasma5.nix
      ./plasma6.nix
      ./xfce.nix
    ];
  };
}
