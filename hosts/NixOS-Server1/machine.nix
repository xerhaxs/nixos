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
    intelgpu.enable = true;
  };

  nixos.system.initrdssh = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyndaaCmTLHdA5+sLBbxgSZNC6KXKtZkKiMK6AAY8Rt jf@NixOS-Desktop"
    ];
    kernelModules = [ "r8169" ];
  };

  nixos.system.secureboot.enable = true;
  nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true;

  nixos.server.dataDir = "/pool01/applications";
  nixos.server.fileshare.share.path = "/pool01/shares";

  nixos.system.clamav = {
    extraScanDirectories = [ "/pool01/shares" ];
    excludePaths = [ "^/pool01/shares/video" ];
  };
}
