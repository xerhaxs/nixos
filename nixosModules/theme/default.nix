{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme-latte.nix
    ./theme-mocha.nix
    ./theme-papirus-icons.nix
    ./theme-plymouth.nix
  ];
}
