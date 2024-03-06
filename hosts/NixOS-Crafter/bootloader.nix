{ config, lib, pkgs, fetchgit, ... }:

{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    device = pkgs.lib.mkDefault "/dev/sda1";
    efiSupport = pkgs.lib.mkDefault false;
    efiInstallAsRemovable = pkgs.lib.mkDefault true;
    gfxmodeBios = "auto";
    gfxpayloadBios = "text";
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.initrd.systemd.enable = true;
}
