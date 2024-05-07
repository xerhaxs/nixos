{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = false;
  
  boot.loader.grub = {
    device = lib.mkForce "/dev/disk/by-label/BOOT";
    efiSupport = lib.mkForce false;
    efiInstallAsRemovable = lib.mkForce false;
    gfxmodeBios = "1600x900";
    gfxpayloadBios = "text";
  };

  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkForce "/dev/disk/by-label/LUKS";
    };
  };
}
