{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ (import ../vps-uplink.nix "serverGaming") ];

  networking = {
    hostName = "NixOS-ServerGaming";

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    tempAddresses = lib.mkForce "disabled";
  };

  nixos.system.networking = {
    enable = true;
    networkmanager.enable = false;
    lan.enable = false;
  };

  nixos.system.ssh.whitelist = [ "10.100.0.0/24" ];
}
