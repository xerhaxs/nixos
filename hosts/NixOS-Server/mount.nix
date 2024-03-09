{ config, pkgs, ... }:

{
  boot.initrd.luks.devices = {
   "crypt" = {
      device = "/dev/disk/by-partlabel/disk-VAR-LUKS";
      preLVM = true;
      keyFile = "/mnt-root/root/keyfile.key";
    };
  };

  fileSystems."/var" = {
    device = "/dev/crypt/var";
    fsType = "ext4";
  };
}
