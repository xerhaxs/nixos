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
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = lib.mkForce "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
  };
}