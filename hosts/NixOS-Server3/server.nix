{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet = {
    lidarr.enable = true;
    nzbhydra2.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sabnzbd.enable = true;
    sonarr.enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = false;
    package = pkgs.mullvad;
  };

  users.groups.truenas = {
    members = [
      "lidarr"
      "radarr"
      "readarr"
      "sabnzbd"
      "sonarr"
    ];
  };
}