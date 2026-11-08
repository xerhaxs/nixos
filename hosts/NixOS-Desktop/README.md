# NixOS-Desktop

## Purpose

Main desktop (AMD), Plasma 6, additional data disks (`mount.nix`), Back In Time daily backup, TPM2.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- Installation and maintenance: [`README.md`](../../README.md#installation), host specific steps in [its section](../../README.md#clients).

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `bootloader.nix` | Boot loader settings of this machine (resolution). |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `mount.nix` | Additional encrypted data disks (crypttab, mounts). |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
| `xserver.nix` | X server settings of this machine (monitor). |
