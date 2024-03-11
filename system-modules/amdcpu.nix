{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-amd" ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  #hardware = {
  #  enableAllFirmware = true;
  #  enableRedistributableFirmware = true;
  #  cpu.amd.updateMicrocode = true;
  #};

  environment.systemPackages = [
    pkgs.microcodeAmd
  ];
}