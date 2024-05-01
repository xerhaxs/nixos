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
          name = "SYSTEM";
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
                  #mountOptions = [
                  #  "defaults"
                  #];
                };
              };
              luks = {
                name = "crypt";
                size = "100%";
                content = {
                  name = "crypt";
                  type = "luks";
                  extraOpenArgs = [ "--cipher aes-xts-plain64" "--key-size 512" "--hash sha512" ];
                  settings = {
                    keyFile = "/tmp/secret.key";
                    allowDiscards = true;
                  };
                  additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  content = {
                    type = "lvm_pv";
                    vg = "crypt";
                  };
                };
                #initrdUnlock = true;
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
              size = "40%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            home = {
              name = "home";
              size = "100%FREE";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
            raw = {
              size = "10M";
            };
          };
        };
      };
    };
  };
}