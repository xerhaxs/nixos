{ config, lib, pkgs, ... }: 

with lib;

{ 
  options.nixos = {
    disko = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable disko modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.disko.enable {
    imports = [
      ./disko-bios-lvm-on-luks.nix
      ./disko-uefi-lvm-on-luks.nix
    ];
  };
}
