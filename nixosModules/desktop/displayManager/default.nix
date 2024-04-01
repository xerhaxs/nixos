{ config, lib, pkgs, ... }:

{
  imports = [
    ./gdm.nix
    ./sddm.nix
  ];
}
