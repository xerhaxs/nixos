{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    home = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable home modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.home.enable {
    imports = [
      ./home.nix
      ./sessionVariables.nix
    ];
  };
}