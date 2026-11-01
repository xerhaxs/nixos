{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.plasma.configFile = {
    "plasmaparc"."General" = {
      "GlobalMuteSourcesMutedDevices" =
        "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input.0";
    };
  };

  homeManager.applications.tools.backintime.dailyProfile = 1;

  # VRR and HDR of the main monitor (Post-Installation), applied at every login.
  programs.plasma.startup.startupScript."kscreen" = {
    text = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-1.vrrpolicy.automatic output.DP-1.hdr.enable output.DP-1.wcg.enable";
    runAlways = true;
    priority = 2;
  };
}
