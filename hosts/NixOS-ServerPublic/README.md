# NixOS-ServerPublic

## Purpose

Public VPS: mail, Matrix, CryptPad, ntfy, Miniflux, Briar Mailbox; backups only through the Contabo portal.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- Installation and maintenance: [`README.md`](../../README.md#installation), host specific steps in [its section](../../README.md#vps).

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `backup.nix` | Nightly PostgreSQL dumps to `/var/backup/postgresql` (persistent), picked up by the backup in the Contabo portal. |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
| `server.nix` | Enabled server services (on NixOS-Portable: the `server` specialisation). |
