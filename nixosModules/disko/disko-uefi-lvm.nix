{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:

{
  options.nixos = {
    disko.disko-uefi-lvm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-uefi-lvm.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-uefi-lvm.enable {
    disko.devices = {
      disk = {
        vda = {
          name = "NIXOS";
          type = "disk";
          device = builtins.elemAt disks 0;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                name = "BOOT";
                type = "EF00";
                size = "500M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "defaults"
                  ];
                  extraArgs = [ "-n" "BOOT" ];
                };
              };
              primary = {
                name = "SYSTEM";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        pool = {
          type = "lvm_vg";
          lvs = {
            swap = {
              name = "swap";
              size = "4G";
              #size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
                extraArgs = [ "-L swap" ];
              };
            };
            root = {
              name = "root";
              size= "100G";
              #size = "75%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                ];
                extraArgs = [ "-L root" ];
              };
            };
            home = {
              name = "home";
              size = "100%FREE";
              #size = "25%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                extraArgs = [ "-L home" ];
              };
            };
          };
        };
      };
    };
  };
}