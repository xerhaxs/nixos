{ config, lib, pkgs, ... }:

{
  imports = [
    ./catppuccin.nix
    ./dracula.nix
    ./theme.nix
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
    catppuccin.enable = true;
    dracula.enable = true;
    theme.enable = true;
  };
}
