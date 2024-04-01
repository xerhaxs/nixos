{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./disko-bios-lvm-on-luks.nix
    ./disko-uefi-lvm-on-luks.nix
  ];
}
