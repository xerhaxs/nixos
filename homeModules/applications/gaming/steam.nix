{ config, lib, pkgs, flatpak, ... }:

{
  options.homeManager = {
    applications.gaming.steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable steam.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.gaming.steam.enable {
    home.packages = with pkgs; [
      steam
    ];
  };
}