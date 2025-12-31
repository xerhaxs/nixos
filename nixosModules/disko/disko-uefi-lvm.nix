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
    boot.initrd.luks.devices = {
      "system" = {
        preLVM = true;
        allowDiscards = true;
        device = "/dev/disk/by-partlabel/disk-NIXOS-SYSTEM";
      };
    };

    fileSystems."/" = {
      device = "/dev/pool/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/pool/home";
      fsType = "ext4";
    };

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];

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
              size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
                extraArgs = [ "-L swap" ];
              };
            };
            root = {
              name = "root";
              size = "100%FREE";
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
              size = "32G";
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