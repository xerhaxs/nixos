{ pkgs, lib, config, ... }: 

{ 
  imports = [
    ./amdcpu.nix
    ./amdgpu.nix
    ./intelcpu.nix
    ./intelgpu.nix
    ./nvidiagpu.nix
  ];
}
