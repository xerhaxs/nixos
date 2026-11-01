# NixOS-Framework

## Purpose

Framework laptop (AMD), Plasma 6, sops wifi, private DNS, MAC randomization, TPM2.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `bootloader.nix` | Boot loader settings of this machine (resolution). |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `framework.nix` | Framework laptop specific settings (nixos-hardware). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
