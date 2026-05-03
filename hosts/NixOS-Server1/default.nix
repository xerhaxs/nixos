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
    ./server.nix
    ./services.nix
    ./syncthing.nix
    ./usergroupids.nix
    ./zfsmount.nix
  ];
}
