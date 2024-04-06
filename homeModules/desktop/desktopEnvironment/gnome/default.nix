{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable gnome modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.gnome.enable && osConfig.nixos.desktop.desktopEnvironment.gnome.enable) {
    imports = [
      ./dconf.nix
      ./gnome.nix
    ];
  };
}