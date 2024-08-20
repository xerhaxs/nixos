{ config, lib, pkgs, ... }:

{
  nixos.server.enable = false;

  services.xserver.displayManager.startx.enable = true;

  nixos.server.network.nginx.enable = true;

  nixos.server.usenet.enable = lib.mkForce true;

  networking.firewall.enable = lib.mkForce false;

  services.mullvad-vpn.enable = true;

  environment.systemPackages = [
    pkgs.mullvad
  ];
}