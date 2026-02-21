{ config, pkgs, ... }:

{
  imports = [
    ./xdg.nix
    ./persistent.nix
  ];
}
