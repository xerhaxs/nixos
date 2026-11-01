{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bootloader.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./machine.nix
    ./mount.nix
    ./networking.nix
    ./xserver.nix
  ];
}
