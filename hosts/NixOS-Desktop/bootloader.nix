{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = pkgs.lib.mkForce "3840x1600x32";
}
