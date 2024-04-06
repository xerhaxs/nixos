{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.communication = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable communication modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.communication.enable {
    imports = [
      ./brave.nix
      ./firefox.nix
      ./librewolf.nix
      ./tor.nix
    ];
  };
}