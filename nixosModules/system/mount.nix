{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system.mount = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
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
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/crypt/home";
      fsType = "ext4";
    };
  };
}