{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = pkgs.lib.mkForce "2256x1504x32";
}
