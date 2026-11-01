# home

## Purpose

Home Manager settings of the user on NixOS-Desktop.

## How it works

- Imported by `homeModules/home/home.nix` through `default.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports of the host files. |
| `home.nix` | Home Manager profile of the user on this host (applications, Plasma). |
| `hyprland.nix` | Hyprland monitor configuration. |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `xdg.nix` | User directories of this host. |
