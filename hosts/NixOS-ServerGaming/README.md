# NixOS-ServerGaming

## Purpose

Public VPS for games only: Minecraft with BlueMap and the countdown website, no other services. Backups to NixOS-Server1 and a Storage Box.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- ssh is reachable publicly until this host has a public key in `nixosModules/system/wireguard.nix`, afterwards only through WireGuard.
- The date of the countdown is `target` in `server.nix`.

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
| `server.nix` | Enabled services and the countdown. |
| `wireguard.nix` | WireGuard peer. |
