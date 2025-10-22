{ config, lib, pkgs, ... }:

{
  imports = [
    ./chromium.nix
    ./firefox.nix
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
      chromium.enable = true;
      firefox.enable = true;
      tor.enable = true;
    };
  };
}