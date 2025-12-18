{ config, lib,  pkgs, ... }:

{
  fileSystems."/" = {
    device = "LABEL=root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "LABEL=boot";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "LABEL=esp_sda";
    fsType = "vfat";
  };

  fileSystems."/boot/efi2" = {
    device = "LABEL=esp_sdb";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "LABEL=home";
    fsType = "ext4";
  };
}
