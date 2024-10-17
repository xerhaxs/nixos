{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./framework.nix
    ./hardware-configuration.nix
    ./networking.nix
    #./syncthing.nix
  ];
}
