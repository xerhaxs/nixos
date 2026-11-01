{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Storage, USB and input drivers of common machines, so the initrd can unlock LUKS anywhere.
  boot.initrd.availableKernelModules = [
    "ahci"
    "atkbd"
    "ehci_pci"
    "hid_generic"
    "nvme"
    "ohci_pci"
    "rtsx_pci_sdmmc"
    "sd_mod"
    "sdhci_pci"
    "sr_mod"
    "thunderbolt"
    "uas"
    "usb_storage"
    "usbhid"
    "virtio_blk"
    "virtio_pci"
    "virtio_scsi"
    "vmd"
    "xhci_pci"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
}
