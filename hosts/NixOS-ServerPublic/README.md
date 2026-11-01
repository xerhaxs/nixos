# NixOS-ServerPublic

## Purpose

Public VPS: mail, Nextcloud, Matrix, CryptPad, Mumble, ntfy, Minecraft, code-server, Miniflux, Briar Mailbox; WireGuard hub; backups to NixOS-Server1 and a Storage Box.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `backup.nix` | restic backups of this host. |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `minecraft.nix` | Minecraft server instances. |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
| `server.nix` | Enabled server services (on NixOS-Portable: the `server` specialisation). |
| `wireguard.nix` | WireGuard hub of the network. |
