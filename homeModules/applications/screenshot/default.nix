{ config, lib, pkgs, ... }:

{
  imports = [
    ./flameshot.nix
  ];

  options.homeManager = {
    applications.screenshot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable screenshot modules bundle.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.screenshot.enable {
    homeManager.applications.screenshot = {
      flameshot.enable = true;
    };
  };
}