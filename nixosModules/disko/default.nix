{
  config,
  disko,
  impermanence,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    disko.nixosModules.disko
    impermanence.nixosModules.impermanence
    ./disko-luks-btrfs-tmpfs.nix
    ./disko-client-luks-lvm-ext4.nix
    ./disko-server-luks-btrfs-raid1.nix
    ./disko-server-luks-lvm-ext4.nix
    ./disko-vm-lvm-ext4.nix

    ./disko-uefi-lvm-on-luks.nix
    ./disko-uefi-lvm.nix
  ];

  options.nixos = {
    disko = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.enable {
    nixos.disko = {
      disko-luks-btrfs-tmpfs.enable = lib.mkDefault false;
      disko-client-luks-lvm-ext4.enable = lib.mkDefault false;
      disko-server-luks-btrfs-raid1.enable = lib.mkDefault false;
      disko-server-luks-lvm-ext4.enable = lib.mkDefault false;
      disko-vm-lvm-ext4.enable = lib.mkDefault false;

      disko-uefi-lvm-on-luks.enable = lib.mkDefault false;
      disko-uefi-lvm.enable = lib.mkDefault false;
    };
  };
}
