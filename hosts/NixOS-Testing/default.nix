{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./disko-config.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./sddm.nix
    ./user.nix
  ];
}
