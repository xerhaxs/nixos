{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./backup.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./minecraft.nix
    ./networking.nix
    ./server.nix
    ./temp
    ./wireguard.nix
  ];
}
