{ config, lib, pkgs, ... }: 

{ 
  imports = [
    ./amdcpu.nix
    ./amdgpu.nix
    ./corectrl.nix
    ./intelcpu.nix
    ./intelgpu.nix
    ./nvidiagpu.nix
    ./openrgb.nix
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
      corectrl.enable = false;
      openrgb.enable = false;
    };
  };
}
