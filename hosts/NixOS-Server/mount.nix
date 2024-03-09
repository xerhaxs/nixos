{ config, pkgs, ... }:

{
  fileSystems."/var" = {
    device = "/dev/crypt/var";
    fsType = "ext4";
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-partlabel/disk-VAR-LUKS";
      keyFile = "/root/keyfile.key";
    };
  };
}
