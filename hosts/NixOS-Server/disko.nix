{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm-on-luks.enable = lib.mkDefault true;
  _module.args.disks = [ "/dev/sda" "/dev/sdb" ];
}
