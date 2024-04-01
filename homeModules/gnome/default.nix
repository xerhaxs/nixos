{ config, pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./gnome.nix
  ];
}
