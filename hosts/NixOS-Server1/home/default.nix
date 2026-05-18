{ config, pkgs, ... }:

{
  imports = [
    ./backintime.nix
    ./xdg.nix
  ];
}
