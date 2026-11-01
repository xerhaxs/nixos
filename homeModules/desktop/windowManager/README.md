# windowManager

## Purpose

Window manager user settings.

## How it works

- Hyprland configuration.

## Contents

| Path | Description |
|---|---|
| [`hyprland/`](hyprland/README.md) | Hyprland desktop (second session next to Plasma, selectable in SDDM) with Catppuccin theme. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.windowManager.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.windowManager.enable` | boolean | `false` | Enable windowManager modules bundle. |
