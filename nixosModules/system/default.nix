{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./bootloader.nix
    ./clamav.nix
    ./cron.nix
    ./dbus.nix
    ./firewall.nix
    ./locals.nix
    ./nasmount.nix
    ./networking.nix
    ./nh.nix
    ./nixos.nix
    ./nixosvm.nix
    ./powermanagement.nix
    ./secureboot.nix
    ./sops.nix
    ./ssh.nix
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
      boot.enable = true;
      bootloader.enable = true;
      clamav.enable = true;
      cron.enable = true;
      dbus.enable = true;
      firewall.enable = true;
      locals.enable = true;
      nasmount.enable = lib.mkDefault true;
      networking.enable = true;
      nh.enable = true;
      nixos.enable = true;
      nixosvm.enable = true;
      powermanagement.enable = true;
      secureboot.enable = lib.mkDefault false;
      sops.enable = true;
      ssh.enable = true;
      user.enable = true;
    };
  };
}
