{ config, lib, pkgs, ... }:

with lib;

{
  options.nixos = {
    hardware.intelcpu = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable intelcpu support.";
      };
    };
  };

  config = mkIf config.nixos.hardware.intelcpu.enable {
    boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.initrd.availableKernelModules = [ "snd-hda-intel" ];
    
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;
    };

    environment.systemPackages = [
      pkgs.microcodeIntel
    ];
  };
}