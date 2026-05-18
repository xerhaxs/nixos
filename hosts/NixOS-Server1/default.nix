{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./backintime.nix
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
