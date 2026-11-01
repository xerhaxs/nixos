# displayManager

## Purpose

Login manager (SDDM) and the default session.

## How it works

- `defaultSession` selects the session that is preselected on login.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.desktop.displayManager.enable`. |
| `sddm.nix` | Enable SDDM display manager. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.desktop.displayManager.defaultSession` | string |  | Set the default session for display manager. |
| `nixos.desktop.displayManager.enable` | boolean | `false` | Enable displayManager modules bundle. |
| `nixos.desktop.displayManager.sddm.enable` | boolean | `false` | Enable SDDM display manager. |
