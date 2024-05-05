{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = lib.mkForce "3840x1600x32";
}
