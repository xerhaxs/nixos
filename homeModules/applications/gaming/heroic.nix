{ config, lib, pkgs, flatpak, ... }:

{
  options.homeManager = {
    applications.gaming.heroic = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable heroic.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.heroic.enable {
    services.flatpak = {
      packages = [
        "com.heroicgameslauncher.hgl"
      ];
    };
  };
}