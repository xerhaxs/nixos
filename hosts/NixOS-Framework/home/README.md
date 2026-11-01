# home

## Purpose

Home Manager settings of the user on NixOS-Framework.

## How it works

- Imported by `homeModules/home/home.nix` through `default.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports of the host files. |
| `framework.nix` | Framework laptop specific settings (nixos-hardware). |
| `home.nix` | Home Manager profile of the user on this host (applications, Plasma). |
| `hyprland.nix` | Hyprland monitor configuration. |
| `xdg.nix` | User directories of this host. |
