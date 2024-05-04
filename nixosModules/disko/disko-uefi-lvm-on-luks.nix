{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:

{
  options.nixos = {
    disko.disko-uefi-lvm-on-luks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-uefi-lvm-on-luks.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-uefi-lvm-on-luks.enable {
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
                  extraArgs = [ "-n BOOT" ];
                };
              };
              luks = {
                name = "luks";
                size = "100%";
                content = {
                  name = "crypt";
                  type = "luks";
                  extraOpenArgs = [
                    "--timeout 10"
                  ];
                  settings = {
                    keyFile = "/tmp/secret.key";
                    #keyFileSize = 512 * 64; # match the `bs * count` of the `dd` command
                    #keyFileOffset = 512 * 128; # match the `bs * skip` of the `dd` command
                    #fallbackToPassword = true;
                    allowDiscards = true;
                  };
                  initrdUnlock = true;
                  additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "system";
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
        system = {
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
              size = "40%FREE";
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