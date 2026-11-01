# desktop

## Purpose

Graphical desktop: desktop environments, window managers, display manager, xdg portals and X server settings.

## How it works

- Enabled per host with `nixos.desktop.enable` and the choice of environment (Plasma 6, Hyprland) and display manager (SDDM).

## Contents

| Path | Description |
|---|---|
| [`desktopEnvironment/`](desktopEnvironment/README.md) | Desktop environments (KDE Plasma 6). |
| [`displayManager/`](displayManager/README.md) | Login manager (SDDM) and the default session. |
| [`windowManager/`](windowManager/README.md) | Tiling window managers (Hyprland). |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.desktop.enable`. |
| `xdg.nix` | Enable XDG Portal settings. |
| `xserver.nix` | Enable xserver settings. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.desktop.enable` | boolean | `false` | Enable desktop modules bundle. |
| `nixos.desktop.xdg.enable` | boolean | `false` | Enable XDG Portal settings. |
| `nixos.desktop.xserver.enable` | boolean | `false` | Enable xserver settings. |
