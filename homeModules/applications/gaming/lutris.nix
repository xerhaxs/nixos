{ config, lib, pkgs, flatpak, ... }:

{
  options.homeManager = {
    applications.gaming.lutris = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable lutris.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.lutris.enable {
    home.packages = with pkgs; [
      lutris
    ];
  };
}