{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:

{
  options.nixos = {
    disko.disko-server-luks-lvm-ext4 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-server-luks-lvm-ext4.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-server-luks-lvm-ext4.enable {
    boot.initrd.luks.devices = {
      "system" = {
        preLVM = true;
        device = "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
      };
    };

    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 4*1024;
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
                  extraArgs = [ "-n" "BOOT" ];
                };
              };
              luks = {
                name = "LUKS";
                size = "100%";
                content = {
                  name = "system";
                  type = "luks";
                  extraOpenArgs = [
                    "--timeout 10"
                  ];
                  settings = {
                    keyFile = "/tmp/secret.key";
                    allowDiscards = true;
                  };
                  initrdUnlock = true;
                  additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "crypt";
                  };
                  extraFormatArgs = [
                    "--type luks2"
                    "--cipher aes-xts-plain64"
                    "--hash sha512"
                    "--iter-time 2000"
                    "--key-size 512"
                    "--pbkdf argon2id"
                    "--use-random"
                    "--label LUKS"
                  ];
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        crypt = {
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