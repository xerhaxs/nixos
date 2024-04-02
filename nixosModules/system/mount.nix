{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system.mount = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable mounting default drives.";
      };
    };
  };

  config = mkIf config.nixos.system.mount.enable {
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