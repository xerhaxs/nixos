{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm.enable = true;
  _module.args.disks = [ "/dev/sda" ];
}
