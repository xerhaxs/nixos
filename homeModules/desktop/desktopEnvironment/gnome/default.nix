{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./gnome.nix
  ];

  options.homeManager = {
    desktop.desktopEnvironment.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable gnome modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.gnome.enable && osConfig.nixos.desktop.desktopEnvironment.gnome.enable) {
    homeManager.desktop.desktopEnvironment.gnome = {
      dconf.enable = true;
      gnome.enable = true;
    };
  };
}