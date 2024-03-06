{ config, pkgs, ... }:

{
  imports = [
    ./disko-config.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./sddm.nix
    ./user.nix
  ];
}
