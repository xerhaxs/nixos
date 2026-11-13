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
    ./minecraft.nix
    ./networking.nix
    ./server.nix
    ./temp
  ];
}
