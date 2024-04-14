{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme-latte.nix
    ./theme-mocha.nix
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
    theme-latte.enable = false;
    theme-mocha.enable = true;
    theme-papirus-icons.enable = true;
    theme-plymouth.enable = true;
  };
}
