{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm.enable = lib.mkForce true;
  _module.args.disks = [ "/dev/sda" ]; # [ "/dev/sda" "/dev/sdb" ];
}
