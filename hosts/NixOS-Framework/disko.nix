{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixos.disko.disko-luks-btrfs-tmpfs.enable = true;
  _module.args.disks = [ "/dev/nvme0n1" ];
}
