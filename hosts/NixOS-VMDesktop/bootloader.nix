{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
    };
  };
}
