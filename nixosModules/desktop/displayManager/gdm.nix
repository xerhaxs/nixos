{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.displayManager.gdm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable GDM display manager.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.displayManager.gdm.enable {
    services.xserver = {
      displayManager = {
        gdm = {
          enable = true;
          #banner = "Hello World!";
          wayland = true;
          autoSuspend = true;
          #settings = {};
        };
        defaultSession = "${config.nixos.desktop.displayManager.defaultSession}";
        #setupCommands = ""; # commands to run after displayManager has launched
      };
    };
  };
}
