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
    services.flatpak = {
      packages = [
        "com.valvesoftware.Steam"
      ];
      
      preSwitchCommand = [
        "com.valvesoftware.Steam:flatpak override --user --filesystem=/mount/Games/Spiele/Steam/ com.valvesoftware.Steam"
      ];
    };
  };
}