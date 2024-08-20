{ config, lib, pkgs, ... }:

{
  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet.enable = true;

  networking.firewall.enable = lib.mkForce false; # only for testing purpos

  services.mullvad-vpn.enable = true;

  environment.systemPackages = [
    pkgs.mullvad
  ];
}