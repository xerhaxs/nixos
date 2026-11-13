{
  config,
  lib,
  pkgs,
  ...
}:

# Runs here only for testing. To remove it: delete this folder and its import in ../default.nix and
# the DNS record (TODO, last phase).
{
  nixos.server.game.countdown = {
    enable = true;
    # Date of the countdown, with the time zone offset.
    target = "2026-11-13T19:00:00+01:00";
    title = "Bis du wieder zu Hause ist";
    subtitle = "und wir uns endlich wiedersehen.";
    doneText = "Wir sind wieder zusammen! <3";
  };
}
