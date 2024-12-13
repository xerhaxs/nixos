{ config, lib, pkgs, ... }:

{
  boot.loader.grub.gfxmodeEfi = pkgs.lib.mkForce "1920x1280x24";
}
