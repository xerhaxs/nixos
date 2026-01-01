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
    boot.initrd.luks.devices = {
      "system" = {
        preLVM = true;
        allowDiscards = true;
        device = "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
      };
    };
    
    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    fileSystems."/" = {
      device = "tmpfs"; #nodev or none or tmpfs??
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=50%"
        "mode=0755"
        "relatime"
      ];
    };

    fileSystems."/persistent" = {
      device = "/dev/mapper/system";
      neededForBoot = true;
      fsType = "btrfs";
      options = [
        "subvol=/root"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "subvol=/home"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "subvol=/nix"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
      ];
    };

    boot.tmp.cleanOnBoot = true;

    fileSystems."/tmp" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "subvol=/tmp"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
      ];
    };

    fileSystems."/swap" = {
      device = "/dev/mapper/system";
      fsType = "btrfs";
      options = [
        "subvol=/swap"
        "compress=no"
        "ssd"
        "noatime"
        "discard=async"
        "nodiratime"
        "space_cache=v2"
      ];
    };

    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 2 * 1024;
      }
    ];

    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [
        "/persistent"
        "/home"
        "/nix"
        "/tmp"
        "/swap"
      ];
    };

    environment.persistence."/persistent" = {
      enable = true;
      hideMounts = false;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/root/keys"
        #"/etc/NetworkManager/system-connections"
        #{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
      ];
      #files = [
      #  "/etc/machine-id"
      #  { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
      #];
      #users.${config.nixos.system.user.defaultuser.name} = {
        #directories = [
          #"Downloads"
          #"Music"
          #"Pictures"
          #"Documents"
          #"Videos"
          #{ directory = ".gnupg"; mode = "0700"; }
          #{ directory = ".ssh"; mode = "0700"; }
          #{ directory = ".nixops"; mode = "0700"; }
          #{ directory = ".local/share/keyrings"; mode = "0700"; }
          #".local/share/direnv"
        #];
        files = [
          "/root/.bash_history"
        ];
      #};
    };

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

                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" "-L SYSTEM" ];
                    subvolumes = {
                      "/root" = {
                        mountpoint = "/persistent";
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
                      "/tmp" = {
                        mountpoint = "/tmp";
                        mountOptions = [
                          "compress=no"
                          "noatime"
                        ];
                      };
                      "/swap" = {
                        mountpoint = "/swap";
                        mountOptions = [
                          "compress=no"
                          "noatime"
                          "nodatacow"
                        ];
                        swap = {
                          swapfile.size = "32G";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}