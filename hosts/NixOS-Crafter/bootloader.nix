{ config, lib, pkgs, ... }:

{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    device = lib.mkForce "/dev/disk/by-partlabel/BOOT";
    efiSupport = lib.mkForce false;
    efiInstallAsRemovable = lib.mkForce true;
    gfxmodeBios = "1600x900";
    gfxpayloadBios = "text";
  };

  boot.initrd.luks.devices = {
   "crypt" = {
      device = lib.mkForce "/dev/disk/by-partlabel/LUKS";
      preLVM = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.initrd.systemd.enable = true;
}
