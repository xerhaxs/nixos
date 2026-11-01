# NixOS-VMDesktop

## Purpose

Virtual machine with the profile of NixOS-Desktop.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
