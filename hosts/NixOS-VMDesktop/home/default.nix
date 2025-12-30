{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./xdg.nix
  ];
}
