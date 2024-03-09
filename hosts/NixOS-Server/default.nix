{ config, pkgs, ... }:

{
  imports = [
    #./server

    #./bootloader.nix
    ./hardware-configuration.nix
    #./mount.nix
    ./networking.nix
    ./user.nix
  ];
}
