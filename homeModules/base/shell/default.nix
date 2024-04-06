{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    base.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable shell modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.shell.enable {
    imports = [
      ./bash.nix
      ./starship.nix
    ];
  };
}