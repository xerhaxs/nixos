{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ (import ../vps-uplink.nix "serverPublic") ];

  networking = {
    hostName = "NixOS-ServerPublic";

    # Own recursive resolver (unbound, DNSSEC): Quad9 refuses every query from France since
    # 24.11.2026, GeoIP puts the VPS there. mkForce drops the 127.0.0.1 and ::1 on port 53 that the
    # unbound module adds, unbound listens on 5335.
    nameservers = lib.mkForce [ "127.0.0.1:5335" ];

    tempAddresses = lib.mkForce "disabled";
  };

  nixos.system.networking = {
    enable = true;
    networkmanager.enable = false;
    lan.enable = false;
  };

  nixos.server.network.unbound.enable = true;
  # No TLS to the local resolver.
  services.resolved.settings.Resolve.DNSOverTLS = lib.mkForce "no";
}
