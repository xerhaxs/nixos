{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.network.ddclient.enable = true;

  #nixos.server.usenet.enable = true;

  nixos.server.usenet = {
    lidarr.enable = false;
    nzbget.enable = true;
    nzbhydra2.enable = true;
    radarr.enable = false;
    readarr.enable = false;
    sabnzbd.enable = true;
    sonarr.enable = false;
  };

  services.mullvad-vpn.enable = true;

  users.groups.truenas = {
    members = [
      "lidarr"
      "radarr"
      "sabnzbd"
      "sonarr"
      "nzbget"
    ];
  };

  environment.systemPackages = [
    pkgs.mullvad
  ];
}