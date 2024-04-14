{ config, lib, pkgs, ... }:

{
  options = {
    nixos.virtualisation.podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable podman virtualisation.";
      };
    };
  };

  config = lib.mkIf config.nixos.virtualisation.podman.enable {
    virtualisation.podman = {
      enable = true;
      enableNvidia = lib.mkIf (config.hardware.nvidia.enable && config.nixos.virtualisation.podman.enable) true;
    };
  };
}
