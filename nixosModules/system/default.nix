{ config, lib, pkgs, ... }:

{
  imports = [
    ./audio.nix
    ./bootloader.nix
    ./clamav.nix
    ./cron.nix
    ./dbus.nix
    ./dconf.nix
    ./firewall.nix
    ./fonts.nix
    ./locals.nix
    ./mount.nix
    ./nasmount.nix
    ./networking.nix
    ./nh.nix
    ./nixos.nix
    ./nixosvm.nix
    ./powermanagement.nix
    ./secureboot.nix
    ./sops.nix
    ./ssh.nix
    ./swap.nix
    ./user.nix
  ];

  options.nixos = {
    system = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable system modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.enable {
    nixos.system = {
      audio.enable = true;
      bootloader.enable = true;
      clamav.enable = true;
      cron.enable = true;
      dbus.enable = true;
      dconf.enable = true;
      firewall.enable = true;
      fonts.enable = true;
      locals.enable = true;
      mount.enable = true;
      nasmount.enable = true;
      networking.enable = true;
      nh.enable = true;
      nixos.enable = true;
      nixosvm.enable = true;
      powermanagement.enable = true;
      secureboot.enable = false;
      sops.enable = true;
      ssh.enable = true;
      swap.enable = true;
      user.enable = true;
    };
  };
}
