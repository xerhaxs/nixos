{ config, lib, pkgs, fetchgit, ... }:

{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    device = pkgs.lib.mkDefault "/dev/disk/by-partlabel/disk-SYSTEM-BOOT";
    efiSupport = pkgs.lib.mkDefault false;
    efiInstallAsRemovable = pkgs.lib.mkDefault true;
    gfxmodeBios = "1600x900";
    gfxpayloadBios = "text";
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.initrd.systemd.enable = true;
}
