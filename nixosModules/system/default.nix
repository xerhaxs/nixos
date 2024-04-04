{ config, lib, pkgs, ... }:

{
  options.nixos = {
    system = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable system modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.system.enable {
    imports = [
      ./audio.nix
      ./bootloader.nix
      ./clamav.nix
      ./cron.nix
      ./dbus.nix
      ./dconf.nix
      ./firewall.nix
      ./fonts.nix
      ./mount
      ./nasmount.nix
      ./locals.nix
      ./networking.nix
      ./nixos.nix
      ./nixosvm.nix
      ./powermanagement.nix
      ./secureboot.nix
      ./sops.nix
      ./ssh.nix
      ./swap.nix
      ./user.nix
    ];
  };
}
