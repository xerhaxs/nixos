{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./hardware-configuration.nix
    ./laptop.nix
    ./networking.nix
  ];
}
