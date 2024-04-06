{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.development = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable development modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.development.enable {
    imports = [
      ./diff.nix
      ./hex.nix
      ./java.nix
      ./jetbrains.nix
      ./pulsar.nix
      ./raspberry.nix
      ./virtualisation.nix
      ./vscodium.nix
    ];
  };
}