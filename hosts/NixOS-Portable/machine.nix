{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "26.05";

  # Runs on unknown machines: all CPU/GPU drivers and firmware, no TPM or Secure Boot binding.
  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
    intelcpu.enable = true;
    intelgpu.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  nixos.system.bootloader = {
    removable = true;
    biosPartitionIndex = 1;
  };

  nixos.disko.disko-luks-btrfs-tmpfs = {
    biosBoot = true;
    swapSize = 8 * 1024;
  };
}
