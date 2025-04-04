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
    #hardware.openrazer = {
    #  enable = true;
    #  devicesOffOnScreensaver = true;
    #  batteryNotifier.enable = true;
    #  syncEffectsEnabled = true;
    #  users = [ "${config.nixos.system.user.defaultuser.name}" ];
    #};
    environment.systemPackages = with pkgs; [
      razergenie
    ];
  };
}
