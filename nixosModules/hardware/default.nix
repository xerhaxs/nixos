{ config, lib, pkgs, ... }: 

{ 
  imports = [
    ./amdcpu.nix
    ./amdgpu.nix
    ./intelcpu.nix
    ./intelgpu.nix
    ./nvidiagpu.nix
  ];

  options.nixos = {
    hardware = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable hardware modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.enable {
    nixos.hardware = {
      amdcpu.enable = lib.mkDefault false;
      amdgpu.enable = lib.mkDefault false;
      intelcpu.enable = lib.mkDefault false;
      intelgpu.enable = lib.mkDefault false;
      nvidiagpu.enable = lib.mkDefault false;
    };
  };
}
