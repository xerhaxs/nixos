{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    desktop.displayManager.gdm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable GDM display manager.";
      };
    };
  };

  config = mkIf config.nixos.desktop.displayManager.gdm.enable {
    services.xserver = {
      displayManager = {
        gdm = {
          enable = true;
          banner = "Hello World!";
          wayland = true;
          autoSuspend = true;
          #settings = {};
        };
        defaultSession = "gnome";
        #setupCommands = ""; # commands to run after displayManager has launched
      };
    };
  };
}
