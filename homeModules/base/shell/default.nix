{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./fish.nix
    ./starship.nix
    ./zsh.nix
  ];

  options.homeManager = {
    base.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable shell modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.enable {
    homeManager.base.shell = {
      bash.enable = lib.mkIf osConfig.nixos.base.shell.bash.enable true;
      fish.enable = lib.mkIf osConfig.nixos.base.shell.fish.enable true;
      starship.enable = true;
      zsh.enable = lib.mkIf osConfig.nixos.base.shell.zsh.enable true;
    };
  };
}