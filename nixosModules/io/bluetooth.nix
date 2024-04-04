{ config, lib, pkgs, ... }:

{
  options.nixos = {
    io.bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable Bluetooth support.";
      };
    };
  };

  config = lib.mkIf config.nixos.io.bluetooth.enable {
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
