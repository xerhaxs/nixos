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

    dataPool = {
      enable = false;
      disks = [ "/dev/sdb" ];
    };
  };

  _module.args.disks = [ "/dev/sda" ];

  #nixos.system.bootloader.biosDevice = "/dev/sda";
}
