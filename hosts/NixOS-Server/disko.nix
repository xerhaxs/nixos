{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-zfs.enable = lib.mkForce true;
  _module.args.disks = [ "/dev/sda" "/dev/sdb" ];

}
