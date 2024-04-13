{ config, lib, pkgs, ... }: 

{ 
  options.nixos = {
    disko = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable disko modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.enable {
    #imports = [
    #  ./disko-bios-lvm-on-luks.nix
    #  ./disko-uefi-lvm-on-luks.nix
    #];
  };
}
