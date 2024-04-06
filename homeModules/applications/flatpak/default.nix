{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.flatpak = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable flatpak modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.flatpak.enable {
    imports = [
      ./flatpak.nix
    ];
  };
}