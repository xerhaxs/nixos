# desktopEnvironment

## Purpose

Desktop environments (KDE Plasma 6).

## How it works

- Plasma 6 with the packages and services it needs (KDE Connect ports, portals, Dolphin plugins).

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.desktop.desktopEnvironment.enable`. |
| `plasma6.nix` | Enable Plasma6 desktop environment. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.desktop.desktopEnvironment.enable` | boolean | `true` | Enable desktopEnvironment modules bundle. |
| `nixos.desktop.desktopEnvironment.plasma6.enable` | boolean | `false` | Enable Plasma6 desktop environment. |
