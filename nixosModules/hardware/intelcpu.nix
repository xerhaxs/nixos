{ config, lib, pkgs, ... }:

{
  options.nixos = {
    hardware.intelcpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable intelcpu support.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.intelcpu.enable {
    boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.initrd.availableKernelModules = [ "snd-hda-intel" ];
    
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;
    };

    environment.systemPackages = with pkgs; [
      microcode-intel
    ];
  };
}