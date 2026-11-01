# desktopEnvironment

## Purpose

Desktop environment user settings.

## How it works

- Plasma 6 via plasma-manager.

## Contents

| Path | Description |
|---|---|
| [`plasma6/`](plasma6/README.md) | KDE Plasma 6 user configuration (plasma-manager). |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.desktopEnvironment.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.desktopEnvironment.enable` | boolean | `false` | Enable desktopEnvironment modules bundle. |
