{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = lib.mkForce "3840x1600x32";

  boot.initrd.luks.devices = lib.mkForce {
    "system" = lib.mkForce {
      device = lib.mkForce "/dev/disk/by-label/CRYPTDRIVE";
      preLVM = true;
    };
  };
}
