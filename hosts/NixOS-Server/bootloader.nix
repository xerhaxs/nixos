{ config, lib, pkgs, ... }:

{
  #boot.loader.grub.gfxmodeEfi = pkgs.lib.mkForce "1920x1200x32";
  boot.initrd.luks.devices = {
   "crypt2" = {
      device = "/dev/disk/by-partlabel/disk-VAR-luks";
      keyFile = "/mnt-root/root/keyfile.key";
      preLVM = true;
    };
  };
}
