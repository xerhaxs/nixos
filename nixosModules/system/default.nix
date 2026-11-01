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
    ./hardening.nix
    ./initrdssh.nix
    ./killswitch.nix
    ./locals.nix
    ./monitoring-agent.nix
    ./networking.nix
    ./nh.nix
    ./nixos.nix
    ./nixosvm.nix
    ./notify.nix
    ./persistent.nix
    ./powermanagement.nix
    ./restic.nix
    ./secureboot.nix
    ./site.nix
    ./smartd.nix
    ./sops.nix
    ./ssh.nix
    ./user.nix
    ./vulnscan.nix
    ./wireguard.nix
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
      hardening.enable = lib.mkDefault true;
      initrdssh.enable = lib.mkDefault false;
      locals.enable = true;
      monitoring-agent.enable = lib.mkDefault true;
      networking.enable = true;
      nh.enable = true;
      nixos.enable = true;
      nixosvm.enable = true;
      persistent.enable = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable true;
      powermanagement.enable = true;
      restic.enable = lib.mkDefault false;
      secureboot.enable = lib.mkDefault false;
      smartd.enable = true;
      sops.enable = true;
      ssh.enable = true;
      user.enable = true;
      vulnscan.enable = lib.mkDefault config.nixos.system.monitoring-agent.enable;
      wireguard.enable = lib.mkDefault false;
    };
  };
}
