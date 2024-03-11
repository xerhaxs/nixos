{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    enableCryptodisk = true;
    gfxmodeEfi = "1920x1200x32";
    gfxpayloadEfi = "keep";
    useOSProber = true;
    configurationLimit = 16;
    configurationName = "NixOS-GRUB";
    extraEntries = ''
      menuentry "Reboot" {
        reboot
      }

      menuentry "Shut Down" {
        halt
      }

      menuentry "Firmware" {
        fwsetup
      }
    '';
  };

  boot.loader.efi.efiSysMountPoint = "/boot/";

  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices = {
   "crypt" = {
      device = "/dev/disk/by-partlabel/disk-SYSTEM-luks";
      preLVM = true;
    };
  };
}
