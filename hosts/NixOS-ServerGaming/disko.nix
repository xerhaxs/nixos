{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.disko.disko-luks-btrfs-tmpfs = {
    enable = true;
    swapSize = 4 * 1024;
    # Contabo VPS boot by legacy BIOS (no /sys/firmware/efi, checked on NixOS-ServerPublic 07.11.2026).
    biosBoot = true;
  };

  _module.args.disks = [ "/dev/sda" ];

  # No EFI variables without UEFI, the ESP stays as a fallback.
  nixos.system.bootloader = {
    biosDevice = "/dev/sda";
    biosPartitionIndex = 1;
    removable = true;
  };
}
