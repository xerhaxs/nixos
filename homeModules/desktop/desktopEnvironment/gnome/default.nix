{ config, lib, pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./gnome.nix
  ];
}
