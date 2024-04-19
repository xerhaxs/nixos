{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./xfce.nix
  ];

  options.homeManager = {
    desktop.desktopEnvironment.xfce = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable xfce modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.xfce.enable && osConfig.nixos.desktop.desktopEnvironment.xfce.enable) {
    homeManager.desktop.desktopEnvironment.xfce = {
      xfce.enable = true;
    };
  };
}