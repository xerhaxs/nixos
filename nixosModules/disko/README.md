# disko

## Purpose

Declarative disk layouts for the installation with disko, including encryption and impermanence.

## How it works

- `disko-luks-btrfs-tmpfs.nix`: ESP + LUKS2 (argon2id) with btrfs subvolumes, the root file system is a tmpfs (impermanence). Persistent data lives in `/persistent`, secrets and keys in `/secrets`.
- Two disks in `_module.args.disks` create a btrfs raid1 over two LUKS containers and a second ESP that is kept in sync.
- `dataPool` adds extra encrypted disk(s) mounted at `/data`, which becomes `nixos.server.dataDir` (`/data/applications`), so application state does not need persistence entries.
- `tpm2` adds TPM2 unlocking (with PIN after enrollment), the passphrase always stays as fallback.
- `disko-vm-lvm-ext4.nix`: simple layout for test VMs.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.disko.enable`. |
| `disko-luks-btrfs-tmpfs.nix` | Enable disko-luks-btrfs-tmpfs. |
| `disko-vm-lvm-ext4.nix` | Enable disko-vm-lvm-ext4. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.disko.disko-luks-btrfs-tmpfs.biosBoot` | boolean | `false` | Add a 1 MiB BIOS boot partition (EF02, partition 1) for legacy BIOS boot with limine (nixos.system.bootloader.biosPartitionIndex = 1). |
| `nixos.disko.disko-luks-btrfs-tmpfs.dataPool.disks` | list of string | `[ ]` | Disks of the data pool (two disks are mirrored with btrfs raid1). |
| `nixos.disko.disko-luks-btrfs-tmpfs.dataPool.enable` | boolean | `false` | Use extra disk(s) as encrypted data pool for the state of the server applications. |
| `nixos.disko.disko-luks-btrfs-tmpfs.dataPool.mountPoint` | string | `"/data"` | Mount point of the data pool. |
| `nixos.disko.disko-luks-btrfs-tmpfs.enable` | boolean | `false` | Enable disko-luks-btrfs-tmpfs. |
| `nixos.disko.disko-luks-btrfs-tmpfs.swapSize` | signed integer | `32768` | Size of the swapfile in MiB. |
| `nixos.disko.disko-luks-btrfs-tmpfs.tpm2` | boolean | `false` | Unlock the system with TPM2 + PIN (enroll: systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 <luks partition>), the passphrase stays as fallback. |
| `nixos.disko.disko-vm-lvm-ext4.enable` | boolean | `false` | Enable disko-vm-lvm-ext4. |
| `nixos.disko.enable` | boolean | `false` | Enable disko modules bundle. |

## Notes

- Enroll TPM2 + PIN: `systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 /dev/disk/by-partlabel/disk-NIXOS-LUKS`, recovery key: `systemd-cryptenroll --recovery-key <device>`. Requires Secure Boot to be set up first.
- The data pool is unlocked after boot with `/secrets/keyfile.key` (crypttab), the installer creates this keyfile.
