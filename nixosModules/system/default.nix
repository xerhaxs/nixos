{ config, lib, pkgs, ... }:

{
  imports = [
    ./clamav.nix
    ./cron.nix
    ./firewall.nix
    ./fonts.nix
    ./locals.nix
    ./networking.nix
    ./swap.nix
    ./upower.nix
  ];
}
