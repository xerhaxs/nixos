{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    #./disko-var-lvm-on-luks.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./server.nix
  ];
}
