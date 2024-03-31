{ config, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/crypt/crypt-root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-SYSTEM-BOOT";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/crypt/crypt-home";
    fsType = "ext4";
  };
}