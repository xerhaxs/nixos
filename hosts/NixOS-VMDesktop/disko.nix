{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-client-luks-lvm-btrfs.enable = true;
  _module.args.disks = [ "/dev/vda" ];
}
