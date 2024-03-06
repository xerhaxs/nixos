{ config, pkgs, ... }:

{
  imports = [
    ./server

    #./bootloader.nix
    ./disko-config.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./sddm.nix
    ./user.nix
  ];
}
