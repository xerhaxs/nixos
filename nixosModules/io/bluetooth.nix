{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    io.bluetooth = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable Bluetooth support.";
      };
    };
  };

  config = mkIf config.nixos.io.bluetooth.enable {
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
