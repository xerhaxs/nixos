{ config, lib, pkgs, ... }:

{
  imports = [
    ./financial.nix
    ./office.nix
  ];

  options.homeManager = {
    applications.office = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable office modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.enable {
    homeManager.applications.office = {
      financial.enable = true;
      office.enable = true;
    };
  };
}