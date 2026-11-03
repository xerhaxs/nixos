{
  config,
  disks ? [ "/dev/vda" ],
  lib,
  pkgs,
  ...
}:

let
  cfg = config.nixos.disko.disko-luks-btrfs-tmpfs;

  mirror = builtins.length disks > 1;
  systemDevice = if mirror then "/dev/mapper/system2" else "/dev/mapper/system";

  luksFormatArgs = label: [
    "--type luks2"
    "--cipher aes-xts-plain64"
    "--hash sha512"
    "--iter-time 2000"
    "--key-size 512"
    "--pbkdf argon2id"
    "--use-random"
    "--label ${label}"
  ];

  subvolume = mountpoint: compress: extra: {
    inherit mountpoint;
    mountOptions = [
      "compress=${compress}"
      "noatime"
    ]
    ++ extra;
  };

  btrfsContent = extraArgs: {
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L SYSTEM"
    ]
    ++ extraArgs;
    subvolumes = {
      "/root" = subvolume "/persistent" "zstd" [ ];
      "/home" = subvolume "/persistent/home" "zstd" [ ];
      "/secrets" = subvolume "/secrets" "zstd" [ ];
      "/nix" = subvolume "/nix" "zstd" [ ];
      "/tmp" = subvolume "/tmp" "no" [ ];
      "/swap" = subvolume "/swap" "no" [ "nodatacow" ];
    };
  };

  mkSystemDisk =
    {
      name,
      device,
      espLabel,
      espMountpoint,
      luksName,
      btrfs,
    }:
    {
      inherit name device;
      type = "disk";
      content = {
        type = "gpt";
        partitions =
          lib.optionalAttrs cfg.biosBoot {
            BIOS = {
              name = "BIOS";
              type = "EF02";
              size = "1M";
              priority = 1;
            };
          }
          // {
            ESP = {
              name = "BOOT";
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = espMountpoint;
                mountOptions = [
                  "defaults"
                ];
                extraArgs = [
                  "-n"
                  espLabel
                ];
              };
            };
            luks = {
              name = "LUKS";
              size = "100%";
              content = {
                name = luksName;
                type = "luks";
                extraOpenArgs = [
                  "--timeout 10"
                ];
                # Only used to format, the passphrase is typed at boot (settings.keyFile would end up in the initrd).
                passwordFile = "/tmp/secret.key";
                settings.allowDiscards = true;
                initrdUnlock = true;
                additionalKeyFiles = [ "/tmp/keyfile.key" ];
                extraFormatArgs = luksFormatArgs (if luksName == "system" then "LUKS" else "LUKS2");
              }
              // lib.optionalAttrs (btrfs != null) { content = btrfs; };
            };
          };
      };
    };

  dataDisks = lib.listToAttrs (
    lib.imap0 (index: device: {
      name = "data${toString index}";
      value = {
        inherit device;
        name = "DATA${toString index}";
        type = "disk";
        content = {
          type = "gpt";
          partitions.luks = {
            name = "LUKS";
            size = "100%";
            content = {
              name = "data${toString index}";
              type = "luks";
              settings = {
                keyFile = "/tmp/keyfile.key";
                allowDiscards = true;
              };
              initrdUnlock = false;
              extraFormatArgs = luksFormatArgs "DATA${toString index}";
            }
            // lib.optionalAttrs (index == builtins.length cfg.dataPool.disks - 1) {
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-L DATA"
                ]
                ++ lib.optionals (index > 0) [
                  "-d raid1"
                  "-m raid1"
                  "/dev/mapper/data0"
                ];
                subvolumes."/data" = subvolume cfg.dataPool.mountPoint "zstd" [ ];
              };
            };
          };
        };
      };
    }) (if cfg.dataPool.enable then cfg.dataPool.disks else [ ])
  );
in

{
  options.nixos = {
    disko.disko-luks-btrfs-tmpfs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable disko-luks-btrfs-tmpfs.";
      };

      swapSize = lib.mkOption {
        type = lib.types.int;
        default = 32 * 1024;
        example = 4096;
        description = "Size of the swapfile in MiB.";
      };

      biosBoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Add a 1 MiB BIOS boot partition (EF02, partition 1) for legacy BIOS boot with limine (nixos.system.bootloader.biosPartitionIndex = 1).";
      };

      tpm2 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Unlock the system with TPM2 + PIN (enroll: systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 <luks partition>), the passphrase stays as fallback.";
      };

      dataPool = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Use extra disk(s) as encrypted data pool for the state of the server applications.";
        };

        disks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "/dev/sdb" ];
          description = "Disks of the data pool (two disks are mirrored with btrfs raid1).";
        };

        mountPoint = lib.mkOption {
          type = lib.types.str;
          default = "/data";
          description = "Mount point of the data pool.";
        };
      };
    };
  };

  config = lib.mkIf config.nixos.disko.disko-luks-btrfs-tmpfs.enable {
    fileSystems."/boot2" = lib.mkIf mirror {
      device = "/dev/disk/by-partlabel/disk-NIXOS2-BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "nosuid"
        "nodev"
        "noexec"
        "nofail"
      ];
    };

    boot.loader.limine.extraInstallCommands = lib.mkIf mirror ''
      ${pkgs.rsync}/bin/rsync -a --delete /boot/ /boot2/
    '';

    environment.etc.crypttab = lib.mkIf cfg.dataPool.enable {
      text = lib.concatImapStrings (index: _: ''
        data${toString (index - 1)} /dev/disk/by-partlabel/disk-DATA${toString (index - 1)}-LUKS /secrets/keyfile.key luks,discard
      '') cfg.dataPool.disks;
    };

    boot.initrd.systemd.tpm2.enable = lib.mkIf cfg.tpm2 true;
    security.tpm2.enable = lib.mkIf cfg.tpm2 true;

    nixos.server.dataDir = lib.mkIf cfg.dataPool.enable (
      lib.mkDefault "${cfg.dataPool.mountPoint}/applications"
    );

    boot.initrd.luks.devices = {
      "system" = {
        allowDiscards = true;
        device = "/dev/disk/by-partlabel/disk-NIXOS-LUKS";
        crypttabExtraOpts = lib.mkIf cfg.tpm2 [ "tpm2-device=auto" ];
      };
      "system2" = lib.mkIf (cfg.tpm2 && mirror) {
        crypttabExtraOpts = [ "tpm2-device=auto" ];
      };
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partlabel/disk-NIXOS-BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
        "nosuid"
        "nodev"
        "noexec"
      ];
    };

    fileSystems."/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=50%"
        "mode=0755"
        "relatime"
      ];
    };

    fileSystems."/persistent" = {
      device = systemDevice;
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

    # The initrd activation creates the persistent home directories, otherwise they end up below the mount point.
    fileSystems."/persistent/home" = {
      device = systemDevice;
      neededForBoot = true;
      fsType = "btrfs";
      options = [
        "subvol=/home"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
      ];
    };

    fileSystems."/secrets" = {
      device = systemDevice;
      neededForBoot = true;
      fsType = "btrfs";
      options = [
        "subvol=/secrets"
        "compress=zstd"
        "ssd"
        "noatime"
        "discard=async"
        "nosuid"
        "nodev"
        "noexec"
      ];
    };

    fileSystems."/nix" = {
      device = systemDevice;
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
      device = systemDevice;
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
      device = systemDevice;
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
        size = config.nixos.disko.disko-luks-btrfs-tmpfs.swapSize;
      }
    ];

    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [
        "/persistent"
        "/secrets"
        "/nix"
        "/tmp"
        "/swap"
      ];
    };

    disko.devices = {
      disk = {
        vda = mkSystemDisk {
          name = "NIXOS";
          device = builtins.elemAt disks 0;
          espLabel = "BOOT";
          espMountpoint = "/boot";
          luksName = "system";
          btrfs = if mirror then null else btrfsContent [ ];
        };
      }
      // lib.optionalAttrs mirror {
        vdb = mkSystemDisk {
          name = "NIXOS2";
          device = builtins.elemAt disks 1;
          espLabel = "BOOT2";
          espMountpoint = "/boot2";
          luksName = "system2";
          btrfs = btrfsContent [
            "-d raid1"
            "-m raid1"
            "/dev/mapper/system"
          ];
        };
      }
      // dataDisks;
    };
  };
}
