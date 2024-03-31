{ config, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/disk-SYSTEM-BOOT";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/home";
    fsType = "ext4";
  };
}