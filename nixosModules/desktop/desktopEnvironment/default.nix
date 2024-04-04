{ config, lib, pkgs, ... }:

{
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
