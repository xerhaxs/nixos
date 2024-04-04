{ config, lib, pkgs, ... }:

{
  options = {
    nixos.virtualisation.podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable podman virtualisation.";
      };
    };
    virtualisation.podman.enableNvidia = {
      default = false;
      example = true;
      enableIf = [
        { option = "hardware.nvidia.enable"; value = true; 
          option = "nixos.virtualisation.podman.enable"; value = true; }
      ];
      description = "Enable nvidia support if needed.";
    };
  };

  config = lib.mkIf config.nixos.virtualisation.podman.enable {
    virtualisation.podman.enable = {
      enable = true;
    };
  };
}
