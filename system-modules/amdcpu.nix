{ config, pkgs, ... }:

{
  #boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-amd" ];
  
  #hardware = {
  #  enableAllFirmware = true;
  #  enableRedistributableFirmware = true;
  #  cpu.amd.updateMicrocode = true;
  #};

  #environment.systemPackages = [
  #  pkgs.microcodeAmd
  #];
}