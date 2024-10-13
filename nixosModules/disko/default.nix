{ config, disko, lib, pkgs, ... }: 

{ 
  imports = [
    disko.nixosModules.disko
    ./disko-bios-lvm-on-luks.nix
    ./disko-uefi-lvm-on-luks.nix
    ./disko-uefi-lvm.nix
    ./disko-uefi-zfs.nix
    ./disko-var-lvm-on-luks.nix
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
      disko-bios-lvm-on-luks.enable = false;
      disko-uefi-lvm-on-luks.enable = false;
      disko-uefi-lvm.enable = false;
      disko-uefi-zfs.enable = false;
      disko-var-lvm-on-luks.enable = false;
    };
  };
}
