{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }: 

{ 
  nixos.disko.disko-uefi-lvm-on-luks.enable = lib.mkForce false;
  _module.args.disks = [ "/dev/sda" ];

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
            size = "4G";
            content = {
              type = "swap";
              resumeDevice = true;
              extraArgs = [ "-L swap" ];
            };
          };
          root = {
            name = "root";
            size = "60%FREE";
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
}
