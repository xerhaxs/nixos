# NixOS-ServerGaming

## Purpose

Public VPS for games: Minecraft with BlueMap. For testing only (`temp/`, removed later): the countdown website, Nextcloud with Collabora and code-server. Backups to NixOS-Server1.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- Installation and maintenance: [`README.md`](../../README.md#installation), host specific steps in [its section](../../README.md#vps).
- ssh is reachable publicly (keys only, sshguard), independent of WireGuard.
- The date of the countdown is `target` in `temp/default.nix`.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `backup.nix` | restic backups of this host. |
| `configuration.nix` | Profile: user name, hardening and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection. |
| `hardware-configuration.nix` | Generated hardware configuration. |
| `machine.nix` | Machine: state version, initrd ssh. |
| `minecraft.nix` | Minecraft server instances, BlueMap and its nginx virtual host. |
| `networking.nix` | Hostname and addresses (`nixos.site.serverGaming`). |
| `server.nix` | Enabled services. |
| [`temp/`](temp/README.md) | Services only for testing (countdown, Nextcloud, code-server), removed later. |
| `wireguard.nix` | WireGuard peer. |
