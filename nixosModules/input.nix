{ config, pkgs, ... }:

{
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
}
