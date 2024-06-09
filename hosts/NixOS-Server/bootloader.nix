{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkForce "/dev/disk/by-partlabel/disk-NIXOS-SYSTEM";
    };
  };
}
