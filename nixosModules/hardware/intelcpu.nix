{ config, pkgs, ... }:

{
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
}