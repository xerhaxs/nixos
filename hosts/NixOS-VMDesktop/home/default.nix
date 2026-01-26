{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./persistent.nix
    ./xdg.nix
  ];
}
