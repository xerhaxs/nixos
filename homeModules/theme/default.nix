{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme-latte.nix
    ./theme-mocha.nix
  ];

  options.homeManager = {
    theme = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable theme modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.theme.enable {
    homeManager.theme = {
      theme-latte = false;
      theme-mocha = false;
    };
  };
}