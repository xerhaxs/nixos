{ config, pkgs, ... }:

{
  imports = [
    #./server

    #./bootloader.nix
    ./disko-var-lvm-on-luks
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./user.nix
  ];
}
