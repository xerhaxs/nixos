{ config, pkgs, ... }:

{
  boot.initrd.luks.devices = {
   "crypt2" = {
      device = "/dev/disk/by-partlabel/disk-VAR-luks";
      keyFile = "/mnt-root/root/keyfile.key";
      preLVM = true;
    };
  };

  fileSystems."/var" = {
    device = "/dev/crypt2/var";
    fsType = "ext4";
  };
}
