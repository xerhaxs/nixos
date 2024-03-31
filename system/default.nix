{ config, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./clamav.nix
    ./common.nix
    ./cron.nix
    ./dbus.nix
    ./dconf.nix
    ./firewall.nix
    ./input.nix
    ./locals.nix
    ./networking.nix
    ./nixosvm.nix
    #./samba-client.nix
    ./sops.nix
    ./swap.nix
    ./upower.nix
    ./user.nix
    ./virtualisation.nix
    ./xdg.nix
    ./xserver.nix

    ../modules
  ];
}
