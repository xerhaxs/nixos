{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./xserver.nix
  ];
}
