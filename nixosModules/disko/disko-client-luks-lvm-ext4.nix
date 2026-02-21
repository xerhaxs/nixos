{
  config,
  disks ? [ "/dev/vda" ],
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    disko.disko-client-luks-lvm-ext4 = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-client-luks-lvm-ext4.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-client-luks-lvm-ext4.enable {
    boot.initrd.luks.devices = {
      "system" = {
        preLVM = true;
        allowDiscards = true;
        device = "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
      };
    };

    fileSystems."/" = {
      device = "/dev/crypt/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "/dev/crypt/home";
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
              size = "256G";
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
