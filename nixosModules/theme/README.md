# theme

## Purpose

System wide theme (Catppuccin).

## How it works

- Accent and flavor are set per host (`nixos.theme.catppuccin`).

## Contents

| Path | Description |
|---|---|
| `catppuccin.nix` | Enable catppuccin theme. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.theme.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.theme.catppuccin.accent` | one of "Blue", "Dark", "Flamingo", "Green", "Lavender", "Light", "Maroon", "Mauve", "Peach", "Pink", "Red", "Rosewater", "Sapphire", "Sky", "Teal", "Yellow" | `"Mauve"` |  |
| `nixos.theme.catppuccin.enable` | boolean | `false` | Enable catppuccin theme. |
| `nixos.theme.catppuccin.flavor` | one of "Latte", "Frappe", "Macchiato", "Mocha" | `"Mocha"` |  |
| `nixos.theme.catppuccin.prefer` | one of "Dark", "Light" | `"Dark"` |  |
| `nixos.theme.catppuccin.size` | one of "Standard", "Compact" | `"Standard"` |  |
| `nixos.theme.catppuccin.tweaks` | one of "Black", "Rimless", "Normal", "Float" | `"Normal"` |  |
| `nixos.theme.catppuccin.winDecStyles` | one of "Modern", "Classic" | `"Modern"` |  |
| `nixos.theme.enable` | boolean | `false` | Enable theme modules bundle. |
