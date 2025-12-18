{ config, lib, pkgs, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiInstallPath = "/boot/efi";
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  boot.swraid.enable = true;
}
