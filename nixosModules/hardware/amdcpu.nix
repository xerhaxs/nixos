{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardware.amdcpu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable amdcpu support.";
      };
    };
  };

  config = mkIf config.nixos.hardware.amdcpu.enable {
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    boot.kernelModules = [ "kvm-amd" ];
    
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };

    environment.systemPackages = [
      pkgs.microcodeAmd
    ];
  };
}