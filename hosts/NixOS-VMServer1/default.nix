{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../NixOS-Server1/configuration.nix
    ../NixOS-Server1/server.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./networking.nix
  ];
}
