{ config, lib, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./mount.nix
    ./networking.nix
    ./ollama.nix
    #./syncthing.nix
    ./xserver.nix
  ];
}
