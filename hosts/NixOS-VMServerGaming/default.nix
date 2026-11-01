{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../NixOS-ServerGaming/configuration.nix
    ../NixOS-ServerGaming/minecraft.nix
    ../NixOS-ServerGaming/server.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./networking.nix
  ];
}
