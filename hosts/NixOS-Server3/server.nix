{ config, lib, pkgs, ... }:

{
  nixos.server.enable = false;

  nixos.server.usenet.enable = true;

  networking.firewall.enable = lib.mkForce false;

  services.mullvad-vpn.enable = true;

  environment.systemPackages = [
    pkgs.mullvad
  ];
}