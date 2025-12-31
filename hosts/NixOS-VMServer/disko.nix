{ config, lib, pkgs, ... }: 

{ 
  #nixos.disko.disko-server-luks-lvm-ext4.enable = true;
  nixos.disko.disko-client-luks-btrfs.enable = true;
  _module.args.disks = [ "/dev/vda" ];
}
