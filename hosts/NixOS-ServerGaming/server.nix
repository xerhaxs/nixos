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
      target = "2027-01-01T18:00:00+01:00";
      title = "Bis Annett wieder zu Hause ist";
      subtitle = "und wir uns endlich wiedersehen";
      doneText = "Annett ist wieder zu Hause";
    };
    minecraft.enable = true;
  };
}
