{ config, lib, pkgs, ... }: 

{ 
  nixos.disko.disko-bios-lvm-on-luks.enable = lib.mkDefault true;
  _module.args.disks = [ "/dev/sda" ];
}
