{ config, pkgs, ... }:

{
  imports = [
    #./server

    #./bootloader.nix
    ./disko-var-lvm-on-luks.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./user.nix
  ];
}
