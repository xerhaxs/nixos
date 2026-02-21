{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    userEnvironment.io.input = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable standard I/O settings.";
      };
    };
  };

  config = lib.mkIf config.nixos.userEnvironment.io.input.enable {
    services = {
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
      # xpadneo.enable = true;
      spacenavd.enable = true;
      i2c.enable = true;
      sensor.iio.enable = true;
    };

    services.hardware.bolt.enable = true;

    users.users."${config.nixos.system.user.defaultuser.name}" = {
      extraGroups = [
        "dialout"
      ];
    };
  };
}
