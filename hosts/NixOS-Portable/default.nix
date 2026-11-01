{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./networking.nix
    ./server.nix
  ];
}
