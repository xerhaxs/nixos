{
  config,
  disks ? [ "/dev/vda" ],
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    disko.disko-vm-lvm-ext4 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-vm-lvm-ext4.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-vm-lvm-ext4.enable {
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

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 1 * 1024;
      }
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
                size = "512M";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "defaults"
                  ];
                  extraArgs = [
                    "-n"
                    "BOOT"
                  ];
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
          };
        };
      };
    };
  };
}
