{ config, lib, pkgs, ... }:

{
  imports = [
    ./cinnamon.nix
    ./gnome.nix
    #./plasma5-bigscreen.nix
    #./plasma5.nix
    ./plasma6.nix
    ./xfce.nix
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
      cinnamon.enable = false;
      gnome.enable = false;
      #plasma5-bigscreen.enable = false;
      #plasma5.enable = false;
      plasma6.enable = false;
      xfce.enable = false;
    };
  };
}
