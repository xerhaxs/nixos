{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.theme.enable {
    imports = [
      ./theme-latte.nix
      ./theme-mocha.nix
    ];
  };
}