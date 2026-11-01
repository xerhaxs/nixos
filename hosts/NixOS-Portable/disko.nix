{
  config,
  lib,
  pkgs,
  ...
}:

let
  # REPLACE with the id of the SSD (ls -l /dev/disk/by-id/), /dev/sdX changes between machines.
  disk = "/dev/disk/by-id/REPLACE-WITH-SSD-ID";
in

{
  nixos.disko.disko-luks-btrfs-tmpfs.enable = true;
  _module.args.disks = [ disk ];

  nixos.system.bootloader.biosDevice = disk;
}
