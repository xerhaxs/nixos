{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:
  
{
  options.nixos = {
    disko.disko-bios-lvm-on-luks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-bios-lvm-on-luks.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-bios-lvm-on-luks.enable {
    disko.devices = {
      disk = {
        vda = {
          name = "NIXOS";
          type = "disk";
          device = "/dev/sda"; #builtins.elemAt disks 0;
          content = {
            type = "table";
            format = "gpt";
            partitions = [
              {
                name = "BOOT";
                start = "1M";
                end = "500M";
                bootable = true;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "defaults"
                  ];
                  #extraArgs = [ "-n BOOT" ];
                };
              }
              {
                name = "LUKS";
                start = "500M";
                end = "100%";
                #part-type = "primary";
                #bootable = true;
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
                  #initrdUnlock = true;
                  additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "crypt";
                  };
                  #extraFormatArgs = [
                  #  "--type luks2"
                  #  "--cipher aes-xts-plain64"
                  #  "--hash sha512"
                  #  "--iter-time 2000"
                  #  "--key-size 512"
                  #  "--pbkdf argon2id"
                  #  "--use-random"
                  #  "--label LUKS"
                  #];
                };
              }
            ];
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
