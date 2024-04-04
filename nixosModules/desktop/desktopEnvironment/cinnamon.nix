{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.desktopEnvironment.cinnamon = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Cinnamon desktop environment.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.desktopEnvironment.cinnamon.enable {
    services.xserver.desktopManager.cinnamon = {
      enable = true;
    };
    
    services.cinnamon.apps.enable = false;

    #environment.cinnamon.excludePackages = with pkgs; [ ];
  };
}
