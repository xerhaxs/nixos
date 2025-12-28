{ config, lib, pkgs, ... }:

{
  options.nixos = {
    userEnvironment.io.bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bluetooth support.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      hsphfpd.enable = false; # disabled for wireplumber
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
