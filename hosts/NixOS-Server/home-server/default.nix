{ config, pkgs, ... }:

{
  imports = [
    ../../../home

    ./xdg.nix
  ];
}
