{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.browser = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable browser modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.enable {
    imports = [
      ./brave.nix
      ./firefox.nix
      ./librewolf.nix
      ./tor.nix
    ];
  };
}