{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.11";

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.clamav.extraScanDirectories = [ "/mount/Data/Datein" ];

  nixos.system.secureboot.enable = true;
  nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true;
}
