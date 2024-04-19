{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./xserver.nix
  ];
}
