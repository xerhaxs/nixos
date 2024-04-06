{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./financial.nix
      ./office.nix
    ];
  };
}