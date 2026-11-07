{
  config,
  lib,
  pkgs,
  ...
}:

# Services that only run here for testing. To remove them: delete this folder and its import in
# ../default.nix, the DNS records and the firewall rules (TODO, last phase).
{
  nixos.server.public = {
    collabora.enable = true;
    nextcloud.enable = true;
  };

  nixos.server.tools.codeserver.enable = true;

  nixos.server.game.countdown = {
    enable = true;
    # Date of the countdown, with the time zone offset.
    target = "2026-11-13T19:00:00+01:00";
    title = "Bis du wieder zu Hause ist";
    subtitle = "und wir uns endlich wiedersehen.";
    doneText = "Wir sind wieder zusammen! <3";
  };

  nixos.system.clamav.extraScanDirectories = [ "${config.services.nextcloud.home}/data" ];
}
