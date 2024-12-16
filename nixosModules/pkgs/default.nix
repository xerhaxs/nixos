{ config, lib, pkgs, ... }:

{
  imports = [
    #./linux-wallpaperengine.nix
    ./wallpaper-engine-kde-plugin.nix
  ];

  options.nixos = {
    pkgs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable pkgs modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.pkgs.enable {
    nixos.pkgs = {
      #linux-wallpaperengine.enable = true;
      wallpaper-engine-kde-plugin.enable = false;
    };
  };
}