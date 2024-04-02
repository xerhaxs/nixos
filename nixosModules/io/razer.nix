{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    io.razer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable Razer mouse support.";
      };
    };
  };

  config = mkIf config.nixos.io.razer.enable {
    hardware.openrazer = {
      enable = true;
      devicesOffOnScreensaver = true;
      mouseBatteryNotifier = true;
      syncEffectsEnabled = true;
      users = [ "${nixos.system.users.defaultuser.name}" ];
    };
    environment.systemPackages = with pkgs; [
      razergenie
    ];
  };
}
