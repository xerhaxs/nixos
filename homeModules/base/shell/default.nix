{ config, lib, osConfig, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./starship.nix
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
      starship.enable = true;
    };
  };
}