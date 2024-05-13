{ config, lib, pkgs, ... }:

{
  imports = [
    ./brave.nix
    ./firefox.nix
    ./librewolf.nix
    ./tor.nix
  ];

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
    homeManager.applications.browser = {
      brave.enable = true;
      firefox.enable = true;
      librewolf.enable = false;
      tor.enable = true;
    };
  };
}