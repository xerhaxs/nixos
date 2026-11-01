{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./backintime.nix
    ./backup.nix
    ./configuration.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./homeassistant.nix
    ./machine.nix
    ./networking.nix
    ./server.nix
    ./services.nix
    ./syncthing.nix
    ./usergroupids.nix
    ./zfsmount.nix
  ];
}
