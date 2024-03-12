{ config, pkgs, ... }:

{
  imports = [
    ./bootloader.nix
    ./driver.nix
    ./hardware-configuration.nix
    ./networking.nix
    #./powersave.nix
    ./sddm.nix
    ./user.nix

    ../../system/audio.nix
    ../../system/bluetooth.nix
    #./bootloader.nix
    #./clamav.nix
    ../../system/common.nix
    ../../system/cron.nix
    ../../system/dbus.nix
    ../../system/dconf.nix
    ../../system/firewall.nix
    ../../system/input.nix
    ../../system/locals.nix
    ../../system/networking.nix
    #./nixosvm.nix
    #./samba-client.nix
    ../../system/sops.nix
    ../../system/swap.nix
    #./upower.nix
    ../../system/xdg.nix
    ../../system/xserver.nix
  ];
}
