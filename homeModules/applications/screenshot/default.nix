{ config, lib, pkgs, ... }:

{
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
    imports = [
      ./flameshot.nix
    ];
  };
}