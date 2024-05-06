{ config, lib, pkgs, ... }:

{
  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };
}