{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    nixos.virtualisation.docker = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable Docker virtualisation.";
      };
    };
    virtualisation.docker.enableNvidia = {
      default = false;
      example = true;
      enableIf = [
        { option = "hardware.nvidia.enable"; value = true; 
          option = "nixos.virtualisation.docker.enable"; value = true; }
      ];
      description = "Enable nvidia support if needed.";
    };
  };

  config = mkIf config.nixos.virtualisation.docker.enable {
    virtualisation.docker.enable = {
      enable = true;
      enableOnBoot = true;
    };
  };
}