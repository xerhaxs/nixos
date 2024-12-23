{ config, lib, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./console.nix
    ./fish.nix
    ./tmux.nix
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
      bash.enable = false; #
      console.enable = false; #
      fish.enable = false; 
      tmux.enable = false; #
      zsh.enable = false;
    };
  };
}