{ config, lib, pkgs, ... }:

let
  hardware_custom = ./hardware-configuration.nix;
  hardware_generated = /etc/nixos/hardware-configuration.nix;
  hardware_installation = /mnt/etc/nixos/hardware-configuration.nix;

  hw_import =
    if builtins.pathExists hardware_custom then hardware_custom
    else if builtins.pathExists hardware_installation then hardware_installation
    else if builtins.pathExists hardware_generated then hardware_generated
    else null;
in

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./mount.nix
    ./networking.nix
    ./server.nix
    hw_import
  ];
}
