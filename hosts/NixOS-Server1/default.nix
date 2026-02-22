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
    ./networking.nix
    ./persistent.nix
    ./server.nix
    ./syncthing.nix
    ./zfsmount.nix
  ];
}
