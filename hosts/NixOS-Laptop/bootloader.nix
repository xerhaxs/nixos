{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = lib.mkForce "1920x1200x32";
}
