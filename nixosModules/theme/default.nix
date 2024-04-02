{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    theme = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.theme.enable {
    imports = [
      ./theme-latte.nix
      ./theme-mocha.nix
      ./theme-papirus-icons.nix
      ./theme-plymouth.nix
    ];
  };
}
