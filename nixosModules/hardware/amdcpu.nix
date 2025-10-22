{ config, lib, pkgs, ... }:

{
  options.nixos = {
    hardware.amdcpu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable amdcpu support.";
      };
    };
  };

  config = lib.mkIf config.nixos.hardware.amdcpu.enable {
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    boot.kernelModules = [ "kvm-amd" "vfio-pci" ];
    
    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };

    environment.systemPackages = with pkgs; [
      microcodeAmd
    ];
  };
}