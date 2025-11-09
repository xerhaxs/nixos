{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet = {
    lidarr.enable = true;
    nzbhydra2.enable = true;
    radarr.enable = false;
    readarr.enable = true;
    sabnzbd.enable = true;
    sonarr.enable = true;
  };

  services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    mullvad
  ];

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