{
  config,
  lib,
  pkgs,
  ...
}:

{
  fileSystems."/" = {
    device = "/dev/md/raid1p2"; # Root-Partition auf mdraid
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/md/raid1p1"; # Boot-Partition auf mdraid, optional
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/sda1"; # ESP auf Disk1
    fsType = "vfat";
  };

  # Optional, ESP spiegeln
  fileSystems."/boot/efi2" = {
    device = "/dev/sdb1"; # ESP auf Disk2
    fsType = "vfat";
  };
}
