{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./locals.nix
    ./networking.nix
  ];
}
