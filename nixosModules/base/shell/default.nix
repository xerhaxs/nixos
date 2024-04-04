{ config, lib, pkgs, ... }:

{
  options.nixos = {
    base.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable shell modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.base.shell.enable {
    imports = [
      ./bash.nix
      ./fish.nix
      ./zsh.nix
    ];
  };
}