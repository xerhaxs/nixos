{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./locals.nix
    ./mount.nix
    ./networking.nix
  ];
}
