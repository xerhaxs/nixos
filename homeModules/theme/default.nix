{ config, lib, nix-colors, osConfig, pkgs, ... }:

{
  imports = [
    nix-colors.homeManagerModules.default
    ./catppuccin.nix
    ./dracula.nix
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
      catppuccin.enable = true;
      dracula.enable = true;
    };
  };
}