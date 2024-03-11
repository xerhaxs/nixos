{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = pkgs.lib.mkForce "3840x1600x32";
  boot.initrd.luks.devices = lib.mkDefault {
    "system" = {
      device = "/dev/disk/by-label/CRYPTDRIVE";
      preLVM = true;
    };
  };
}
