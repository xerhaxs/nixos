{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./desktop.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./sddm.nix
    ./user.nix
    ./xserver.nix
  ];
}
