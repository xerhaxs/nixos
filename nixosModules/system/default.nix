{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    system = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable system modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.system.enable {
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
      ./locals.nix
      ./networking.nix
      ./nixos.nix
      ./nixosvm.nix
      ./powermanagement.nix
      ./swap.nix
      ./user.nix
    ];
  };
}
