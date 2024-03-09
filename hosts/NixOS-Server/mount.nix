{ config, pkgs, ... }:

{
  fileSystems."/var" = {
    device = "/dev/crypt/var";
    fsType = "ext4";
    encrypted = {
      enable = true;
      blkDev = "/dev/disk/by-partlabel/disk-VAR-luks";
      keyFile = "/root/keyfile.key";
    };
  };
}
