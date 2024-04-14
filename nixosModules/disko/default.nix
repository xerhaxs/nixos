{ config, lib, pkgs, ... }: 

{ 
  imports = [
    ./disko-bios-lvm-on-luks.nix
    ./disko-uefi-lvm-on-luks.nix
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
      disko-bios-lvm-on-luks = false;
      disko-uefi-lvm-on-luks = false;
    };
  };
}
