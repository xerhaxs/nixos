{ config, pkgs, ... }:

{
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
}
