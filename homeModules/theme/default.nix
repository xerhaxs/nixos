{ config, lib, nix-colors, osConfig, pkgs, ... }:

{
  imports = [
    nix-colors.homeManagerModules.default
    ./catppuccin.nix
    ./dracula.nix
    ./theme.nix
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
      catppuccin.enable = lib.mkIf osConfig.nixos.theme.theme.colorscheme == "catppuccin" true;
      dracula.enable = lib.mkIf osConfig.nixos.theme.theme.colorscheme == "dracula" true;
      theme.enable = true;
    };
  };
}