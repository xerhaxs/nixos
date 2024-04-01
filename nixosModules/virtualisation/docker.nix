{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    virtualisation.docker = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Docker virtualisation.";
      };
      enableNvidia = {
        default = false;
        enableIf = [
          { option = "hardware.nvidia.open"; value = true; }
        ];
      };
    };
  };

  config = mkIf config.nixos.virtualisation.docker.enable {
    virtualisation.docker.enable = {
      enable = true;
      enableOnBoot = true;
    };
  };
}