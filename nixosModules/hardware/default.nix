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
}
