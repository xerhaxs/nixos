{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../NixOS-ServerPublic/configuration.nix
    ../NixOS-ServerPublic/minecraft.nix
    ../NixOS-ServerPublic/server.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./networking.nix
  ];
}
