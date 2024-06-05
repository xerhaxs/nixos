{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:

{
  options.nixos = {
    disko.disko-uefi-zfs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-uefi-zfs.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-uefi-zfs.enable {
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
              zfs = {
                name = "ZFS";
                size = "100%";
                content = {
                  name = "system";
                  type = "zfs";
                  pool = "zroot";
                  #extraOpenArgs = [
                  #  "--timeout 10"
                  #];
                  #settings = {
                  #  keyFile = "/tmp/secret.key";
                  #  allowDiscards = true;
                  #};
                  #initrdUnlock = true;
                  #additionalKeyFiles = [ "/tmp/keyfile.key" ];
                  #content = {
                  #  type = "lvm_pv";
                  #  vg = "crypt";
                  #};
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
              };
            };
          };
        };
        vdb = {
          type = "disk";
          device = builtins.elemAt disks 1;
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          mode = "mirror";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/";
          postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

          datasets = {
            zfs_fs = {
              type = "zfs_fs";
              mountpoint = "/zfs_fs";
              options."com.sun:auto-snapshot" = "true";
            };
            zfs_unmounted_fs = {
              type = "zfs_fs";
              options.mountpoint = "none";
            };
            zfs_legacy_fs = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/zfs_legacy_fs";
            };
            zfs_testvolume = {
              type = "zfs_volume";
              size = "10M";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/ext4onzfs";
              };
            };
            encrypted = {
              type = "zfs_fs";
              options = {
                mountpoint = "none";
                encryption = "aes-256-gcm";
                keyformat = "passphrase";
                keylocation = "file:///tmp/secret.key";
              };
              # use this to read the key during boot
              # postCreateHook = ''
              #   zfs set keylocation="prompt" "zroot/$name";
              # '';
            };
            "encrypted/test" = {
              type = "zfs_fs";
              mountpoint = "/zfs_crypted";
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