{ config, pkgs, ... }:

{
  imports = [
    ./persistent.nix
    ./xdg.nix
  ];
}
