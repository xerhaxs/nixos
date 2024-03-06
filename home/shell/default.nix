{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./starship.nix
  ];
}
