{ config, lib, pkgs, ... }:

{
  imports = [
    #./color-scheme.nix
    #./catppuccin-latte.nix
    #./catppuccin-mocha.nix
    ./theme-papirus-icons.nix
    ./theme-plymouth.nix
  ];

  options.nixos = {
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.enable {
    #catppuccin-latte.enable = false;
    #catppuccin-mocha.enable = true;
    theme-papirus-icons.enable = true;
    theme-plymouth.enable = true;
  };
}
