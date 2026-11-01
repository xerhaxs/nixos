{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    system.bootloader = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Bootloader.";
      };

      biosDevice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/dev/sda";
        description = "Additionally install limine for legacy BIOS boot on this device (e.g. VPS without UEFI).";
      };

      biosPartitionIndex = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 1;
        description = "Index (1-based) of the BIOS boot partition (EF02) limine embeds its stage 2 into.";
      };

      removable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Install as removable medium (EFI/BOOT/BOOTX64.EFI, no NVRAM entry), boots on any UEFI machine.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.bootloader.enable {
    boot.loader.efi.canTouchEfiVariables = !config.nixos.system.bootloader.removable;

    boot.loader.efi.efiSysMountPoint = "/boot/";

    boot.loader.limine.extraEntries = ''
      /Reboot
        protocol: reboot

      /Power Off
        protocol: poweroff

      /Firmware Setup
        protocol: fwsetup
    '';

    boot.loader.limine = {
      enable = true;
      efiSupport = true;
      enableEditor = false;
      maxGenerations = 8;
      validateChecksums = true;
      panicOnChecksumMismatch = true;
      biosSupport = lib.mkIf (config.nixos.system.bootloader.biosDevice != null) true;
      biosDevice = lib.mkIf (
        config.nixos.system.bootloader.biosDevice != null
      ) config.nixos.system.bootloader.biosDevice;
      partitionIndex = lib.mkIf (
        config.nixos.system.bootloader.biosPartitionIndex != null
      ) config.nixos.system.bootloader.biosPartitionIndex;
      efiInstallAsRemovable = config.nixos.system.bootloader.removable;
    };
  };
}
