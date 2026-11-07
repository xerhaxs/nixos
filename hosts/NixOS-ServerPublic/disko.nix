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
    # The VPS boots by legacy BIOS (no /sys/firmware/efi in the Contabo system, 07.11.2026).
    biosBoot = true;

    dataPool = {
      enable = false;
      disks = [ "/dev/sdb" ];
    };
  };

  _module.args.disks = [ "/dev/sda" ];

  # No EFI variables without UEFI, the ESP stays as a fallback.
  nixos.system.bootloader = {
    biosDevice = "/dev/sda";
    biosPartitionIndex = 1;
    removable = true;
  };
}
