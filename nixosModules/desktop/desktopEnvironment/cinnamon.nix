{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.desktopEnvironment.cinnamon = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable Cinnamon desktop environment.";
      };
    };
  };

  config = mkIf config.nixos.desktop.desktopEnvironment.cinnamon.enable {
    services.xserver.desktopManager.cinnamon = {
      enable = true;
    };
    
    services.cinnamon.apps.enable = false;

    #environment.cinnamon.excludePackages = with pkgs; [ ];
  };
}
