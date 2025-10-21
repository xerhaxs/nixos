{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.network.ddclient.enable = false;

  nixos.server.usenet.enable = false;

  nixos.server.usenet = {
    lidarr.enable = false;
    nzbhydra2.enable = true;
    radarr.enable = false;
    readarr.enable = false;
    sabnzbd.enable = true;
    sonarr.enable = false;
  };

  services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    mullvad
  ];

  users.groups.truenas = {
    members = [
      "lidarr"
      "radarr"
      "sabnzbd"
      "sonarr"
    ];
  };
}