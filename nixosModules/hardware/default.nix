{ config, lib, pkgs, ... }: 

with lib;

{ 
  options.nixos = {
    hardware = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Enable hardware modules bundle.";
      };
    };
  };

  config = mkIf config.nixos.hardware.enable {
    imports = [
      ./amdcpu.nix
      ./amdgpu.nix
      ./corectrl.nix
      ./intelcpu.nix
      ./intelgpu.nix
      ./nvidiagpu.nix
    ];
  };
}
