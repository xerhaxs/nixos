{ config, lib, pkgs, ... }:

{
  # Bootloader
  boot.initrd.availableKernelModules = [ "sr_mod" ];
  boot.kernelParams = [ "quiet" "splash" "loglevel=3" "udev.log-priority=3" "vt.global_cursor_default=1" ];
  boot.kernelModules = [ "fuse" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  security.polkit.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    enableCryptodisk = true;
    gfxmodeEfi = "auto";
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

  services.udisks2.enable = true;

  services.fwupd.enable = true;

  services.acpid.enable = true;

  environment.systemPackages = [
    pkgs.acpid
  ];
}
