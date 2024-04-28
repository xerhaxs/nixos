{ config, lib, pkgs, ... }:

{
  options.nixos = {
    desktop.displayManager.sddm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable SDDM display manager.";
      };
    };
  };

  config = lib.mkIf config.nixos.desktop.displayManager.sddm.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        enableHidpi = false;
      };
      defaultSession = "${config.nixos.desktop.displayManager.defaultSession}";
    };
  };
}
