{ config, lib, pkgs, ... }:

{
  boot.loader.limine.style.interface.resolution = "2256x1504";

  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
    };
  };
}
