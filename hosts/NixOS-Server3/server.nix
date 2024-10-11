{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet.enable = true;

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