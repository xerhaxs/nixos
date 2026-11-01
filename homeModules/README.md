# homeModules

## Purpose

Home Manager modules of the system user. They follow the same pattern as the NixOS modules with `options.homeManager.<category>.<name>`.

## How it works

- `homemanager.nix` integrates Home Manager into NixOS (global pkgs, `osConfig` available).
- The bundles are enabled depending on the NixOS configuration (e.g. desktop applications only with `nixos.desktop.enable`).
- Host specific user settings are in `hosts/<host>/home/`.

## Contents

| Path | Description |
|---|---|
| [`applications/`](applications/README.md) | Desktop applications, grouped by category. |
| [`base/`](base/README.md) | Shell and CLI configuration of the user. |
| [`desktop/`](desktop/README.md) | User side of the desktop: Plasma, Hyprland, xdg and X settings. |
| [`home/`](home/README.md) | Home basics and the import of the host specific home configuration. |
| [`theme/`](theme/README.md) | User theme (Catppuccin). |
| [`userEnvironment/`](userEnvironment/README.md) | Fonts and session variables of the user. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.enable`. |
| `homemanager.nix` |  |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.enable` | boolean | `true` | Enable homeManager modules bundle. |
