{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./catppuccin-latte.nix
    ./catppuccin-mocha.nix
  ];

  options.homeManager = {
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.theme.enable {
    homeManager.theme = {
      catppuccin-latte = lib.mkIf osConfig.nixos.theme.catppuccin-latte.enable true;
      catppuccin-mocha = lib.mkIf osConfig.nixos.theme.catppuccin-mocha.enable true;
    };
  };
}