{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.server.network.nginx.enable = true;

  nixos.server.game = {
    countdown = {
      enable = true;
      # Date of the countdown, with the time zone offset.
      target = "2026-11-13T19:00:00+01:00";
      title = "Bis du wieder zu Hause ist";
      subtitle = "und wir uns endlich wiedersehen.";
      doneText = "Wir sind wieder zusammen! <3";
    };
    minecraft.enable = true;
  };
}
