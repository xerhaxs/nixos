{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = false;
  
  boot.loader.grub = {
    device = lib.mkForce "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
    efiSupport = lib.mkForce false;
    gfxmodeBios = "1600x900";
    gfxpayloadBios = "text";
  };
}
