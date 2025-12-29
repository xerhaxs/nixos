{ config, lib, pkgs, ... }:

{
  boot.loader.limine.style.interface.resolution = "1920x1280";

  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
    };
  };
}
