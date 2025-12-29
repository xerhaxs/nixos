{ config, lib, pkgs, ... }:

{
  boot.loader.limine.style.interface.resolution = "3840x1600x32";

  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
    };
  };
}
