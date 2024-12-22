{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./convertible.nix
    ./disko.nix
    #./hardware-configuration.nix
    /etc/nixos/hardware-configuration.nix
    ./networking.nix
  ];
}
