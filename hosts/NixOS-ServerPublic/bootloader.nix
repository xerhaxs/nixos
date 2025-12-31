{ config, lib, pkgs, ... }:

{
  boot.loader.grub.devices = [ "/dev/sda" "/dev/sdb" ];
  boot.swraid.enable = true;

  # Bootloader
    boot.initrd.availableKernelModules = [ "sr_mod" ];
    boot.kernelParams = [ "quiet" "splash" "loglevel=3" "udev.log-priority=3" "vt.global_cursor_default=1" ];
    boot.kernelModules = [ "fuse" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback vendor-reset ];
    
    boot.extraModprobeConfig = ''
      options devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1 4l2loopback vendor-reset
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

    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    boot.initrd.systemd.enable = true;

    boot.plymouth.enable = true;

    services.udisks2.enable = true;

    services.fwupd.enable = true;

    environment.systemPackages = [
      pkgs.acpid
    ];
}
