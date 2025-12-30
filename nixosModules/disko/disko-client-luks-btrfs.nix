{ config, disks ? [ "/dev/vda" ], lib, pkgs, ... }:

{
  options.nixos = {
    disko.disko-client-luks-btrfs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-client-luks-btrfs.";
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-client-luks-btrfs.enable {
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
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/home" = {
                        mountpoint = "/home";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      };
                      "/swap" = {
                        mountpoint = "/.swapvol";
                        swap.swapfile.size = "20M";
                      };
                    };
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
    };
  };
}