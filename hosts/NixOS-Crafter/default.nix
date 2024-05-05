{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./networking.nix
  ];
}
