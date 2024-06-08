{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm-on-luks.enable = lib.mkForce true;
  _module.args.disks = [ "/dev/sda" ]; # [ "/dev/sda" "/dev/sdb" ];
}
