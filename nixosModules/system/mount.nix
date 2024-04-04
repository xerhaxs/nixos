{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.mount = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable mounting default drives.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.mount.enable {
    fileSystems."/" = {
      device = "/dev/crypt/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-SYSTEM-BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/crypt/home";
      fsType = "ext4";
    };
  };
}