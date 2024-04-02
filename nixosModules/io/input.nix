{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    io.bluetooth = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable standard I/O settings.";
      };
    };
  };

  config = mkIf config.nixos.io.bluetooth.enable {
    services.xserver = {
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
        };

        touchpad = {
          tapping = true;
          accelProfile = "flat";
          scrollMethod = "twofinger";
          naturalScrolling = true;
          middleEmulation = true;
          disableWhileTyping = true;
          clickMethod = "clickfinger";
        };
      };
    };

    services.ratbagd.enable = true;

    hardware = {
      xpadneo.enable = true;
      spacenavd.enable = true;
      i2c.enable = true;
    };
  };
}
