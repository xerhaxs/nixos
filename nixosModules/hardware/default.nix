{ config, lib, pkgs, ... }: 

{ 
  options.nixos = {
    hardware = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Enable hardware modules bundle.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.enable {
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
