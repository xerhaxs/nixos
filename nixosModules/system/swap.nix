{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.swap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Swap file";
      };
    };
  };

  config = lib.mkIf config.nixos.system.swap.enable {
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4*1024;
      }
      {
        device = "/dev/crypt/swap";
        encrypted = {
          enable = true;
          keyFile = "/mnt-root/root/keyfile.key";
          label = "SWAP";
          blkDev = "/dev/disk/by-partlabel/disk-SYSTEM-SWAP";
        };
      }
    ];
  };
}