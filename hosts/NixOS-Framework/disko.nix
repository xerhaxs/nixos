{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm-on-luks.enable = true;
  _module.args.disks = [ "/dev/nvme0n1" ];
}
