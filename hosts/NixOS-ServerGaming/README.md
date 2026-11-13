# NixOS-ServerGaming

## Purpose

Public VPS for games: Minecraft with BlueMap. For testing only (`temp/`, removed later): the countdown website. Backups only through the Contabo portal.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- Installation and maintenance: [`README.md`](../../README.md#installation), host specific steps in [its section](../../README.md#vps).
- ssh is reachable publicly (keys only, sshguard).
- The date of the countdown is `target` in `temp/default.nix`.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `configuration.nix` | Profile: user name, hardening and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection. |
| `hardware-configuration.nix` | Generated hardware configuration. |
| `machine.nix` | Machine: state version, initrd ssh. |
| `minecraft.nix` | Minecraft server instances, BlueMap and its nginx virtual host. |
| `networking.nix` | Hostname and addresses (`nixos.site.serverGaming`). |
| `server.nix` | Enabled services. |
| [`temp/`](temp/README.md) | The countdown website, only for testing, removed later. |
