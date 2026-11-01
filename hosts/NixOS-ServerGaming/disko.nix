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
  };

  _module.args.disks = [ "/dev/sda" ];
}
