# windowManager

## Purpose

Tiling window managers (Hyprland).

## How it works

- Hyprland system integration; the user configuration is in `homeModules/desktop/windowManager/hyprland`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.desktop.windowManager.enable`. |
| `hyprland.nix` | Enable hyprland windowManager. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.desktop.windowManager.enable` | boolean | `false` | Enable windowManager modules bundle. |
| `nixos.desktop.windowManager.hyprland.enable` | boolean | `false` | Enable hyprland windowManager. |
