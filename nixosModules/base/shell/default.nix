{ config, lib, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./console.nix
    ./fish.nix
    ./zsh.nix
  ];

  options.nixos = {
    base.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable shell modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.enable {
    nixos.base.shell = {
      bash.enable = true;
      console.enable = true;
      fish.enable = false;
      zsh.enable = false;
    };
  };
}