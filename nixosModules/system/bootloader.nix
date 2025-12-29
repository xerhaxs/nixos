{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.bootloader = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bootloader.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.bootloader.enable {
  
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      enableEditor = false;
      maxGenerations = 32;
      #validateChecksums = true;
      #secureBoot.enable = true;
      #secureBoot.sbctl = pkgs.sbctl;
      panicOnChecksumMismatch = true;
      style.interface.resolution = "3840x1600";
    };

    boot.loader.efi.efiSysMountPoint = "/boot/";

    #boot.loader.grub = {
    #  enable = true;
    #  device = "nodev";
    #  efiSupport = true;
    #  efiInstallAsRemovable = true;
    #  enableCryptodisk = true;
    #  gfxmodeEfi = "auto";
    #  gfxpayloadEfi = "keep";
    #  useOSProber = true;
    #  configurationLimit = 16;
    #  configurationName = "NixOS-GRUB";
    #  extraEntries = ''
    #    menuentry "Reboot" {
    #      reboot
    #    }

    #    menuentry "Shut Down" {
    #      halt
    #    }

    #    menuentry "Firmware" {
    #      fwsetup
    #    }
    #  '';
    #};
  };
}
