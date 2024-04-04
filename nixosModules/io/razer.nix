{ config, lib, pkgs, ... }:

{
  options.nixos = {
    io.razer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Razer mouse support.";
      };
    };
  };

  config = lib.mkIf config.nixos.io.razer.enable {
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
