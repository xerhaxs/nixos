{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./clamav.nix
    ./cron.nix
    ./firewall.nix
    ./fonts.nix
    ./locals.nix
    ./networking.nix
    ./powermanagement.nix
    ./swap.nix
  ];
}
