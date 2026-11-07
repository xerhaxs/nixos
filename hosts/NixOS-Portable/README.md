# NixOS-Portable

## Purpose

Portable all-in-one installation on one external SSD: every application, hybrid BIOS/UEFI boot, LUKS, impermanence; boot entry `server` starts the offline capable server services on `*.portable.internal`.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- The `server` specialisation has no game server and no Nextcloud. Its services use the own domain `portable.internal` and read their secrets from `server/<name>` in `nixos-portable.yaml` (list `serverSecrets` in `server.nix`), so no value is shared with NixOS-Server1. Monitoring scrapes and probes only this host.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
| `server.nix` | Enabled server services (on NixOS-Portable: the `server` specialisation). |
