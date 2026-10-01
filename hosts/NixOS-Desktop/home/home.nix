{
  config,
  lib,
  pkgs,
  plasma-manager,
  ...
}:

{
  imports = [
    plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    workspace = {
      wallpaperSlideShow = lib.mkForce {
        path = "${config.xdg.userDirs.pictures}/Desktopbilder/Kanada";
        interval = 60;
      };
    };

    configFile = {
      "plasmaparc"."General" = {
        "GlobalMuteSourcesMutedDevices" =
          "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input.0";
      };
    };
  };

  homeManager.applications.enable = true;
}
