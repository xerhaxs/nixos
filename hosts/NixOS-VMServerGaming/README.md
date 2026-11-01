# NixOS-VMServerGaming

## Purpose

Virtual machine with the profile of NixOS-ServerGaming (without WireGuard identity and backups, uses the secrets of NixOS-ServerGaming).

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection. |
| `hardware-configuration.nix` | Generated hardware configuration. |
| `machine.nix` | Machine: state version, secrets, guest tools. |
| `networking.nix` | Hostname and LAN options. |
