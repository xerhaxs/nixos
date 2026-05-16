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
      wallpaper = "${config.xdg.userDirs.pictures}/Desktopbilder/JWST/compress/52338778943_9704c200b4_o.jpg";
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
