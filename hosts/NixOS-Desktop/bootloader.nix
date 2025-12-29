{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = lib.mkForce "3840x1600x32";

  boot.initrd.luks.devices = {
    "system" = {
      preLVM = true;
      device = lib.mkDefault "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
    };
  };
}
