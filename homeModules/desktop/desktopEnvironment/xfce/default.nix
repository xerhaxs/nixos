{ config, lib, osConfig, pkgs, ... }:

{
  options.homeManager = {
    desktop.desktopEnvironment.xfce = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable xfce modules bundle.";
      };
    };
  };

  config = lib.mkIf (config.homeManager.desktop.desktopEnvironment.xfce.enable && osConfig.nixos.desktop.desktopEnvironment.xfce.enable) {
    imports = [
      ./xfce.nix
    ];
  };
}