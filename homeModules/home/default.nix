{ config, lib, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./sessionVariables.nix
  ];

  options.homeManager = {
    home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.enable {
    homeManager.home = {
      home.enable = true;
      sessionVariables.enable = true;
    };
  };
}