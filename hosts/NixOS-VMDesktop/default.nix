{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../NixOS-Desktop/configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./networking.nix
  ];
}
