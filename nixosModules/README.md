# nixosModules

## Purpose

System level NixOS modules. Every module defines `options.nixos.<category>.<name>` and is only active when its `enable` option is set.

## How it works

- `default.nix` imports all categories and enables the bundles `base`, `disko`, `hardware`, `system` and `theme` by default (`lib.mkDefault`, so hosts can override them).
- Each category folder has its own `default.nix` with a bundle option (e.g. `nixos.server.enable`) that enables the modules of the category.
- Hosts in `hosts/` only set options, all implementation stays here so every module can be used on any host.

## Contents

| Path | Description |
|---|---|
| [`base/`](base/README.md) | Basic tools and shell programs available on every host. |
| [`desktop/`](desktop/README.md) | Graphical desktop: desktop environments, window managers, display manager, xdg portals and X server settings. |
| [`disko/`](disko/README.md) | Declarative disk layouts for the installation with disko, including encryption and impermanence. |
| [`hardware/`](hardware/README.md) | CPU and GPU specific settings (microcode, drivers, video acceleration). |
| [`server/`](server/README.md) | Server applications, grouped by category. |
| [`system/`](system/README.md) | Base system: boot, users, networking, security, secrets, backups, monitoring and notifications. |
| [`theme/`](theme/README.md) | System wide theme (Catppuccin). |
| [`userEnvironment/`](userEnvironment/README.md) | System parts of the user environment on desktops: games, I/O, fonts, browser policies, sync and network shares. |
| [`virtualisation/`](virtualisation/README.md) | Virtualisation and containers. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.nixosModules.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.nixosModules.enable` | boolean | `true` | Enable nixosModules modules bundle. |
