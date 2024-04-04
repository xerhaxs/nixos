{ config, lib, pkgs, ... }:

{
  options.nixos = {
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.enable {
    imports = [
      ./theme-latte.nix
      ./theme-mocha.nix
      ./theme-papirus-icons.nix
      ./theme-plymouth.nix
    ];
  };
}
