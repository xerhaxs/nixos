# plasma6

## Purpose

KDE Plasma 6 user configuration (plasma-manager).

## How it works

- Panels, shortcuts, Dolphin, dconf settings.

## Contents

| Path | Description |
|---|---|
| `dconf.nix` | Enable dconf |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.desktopEnvironment.plasma6.enable`. |
| `dolphin.nix` | Enable dolphin. |
| `plasma6.nix` | Enable plasma6. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.desktopEnvironment.plasma6.dconf.enable` | boolean | `false` | Enable dconf |
| `homeManager.desktop.desktopEnvironment.plasma6.dolphin.enable` | boolean | `false` | Enable dolphin. |
| `homeManager.desktop.desktopEnvironment.plasma6.dolphin.places` | list of (submodule) | `[ { title = "Minecraft"; url = "sftp://admin@NixOS-ServerGaming/srv/minecraft"; icon = "network-server"; } ]` | Entries added to the places panel if missing (removing one in Dolphin brings it back at the next activation). |
| `homeManager.desktop.desktopEnvironment.plasma6.enable` | boolean | `false` | Enable plasma6 modules bundle. |
| `homeManager.desktop.desktopEnvironment.plasma6.plasma6.enable` | boolean | `false` | Enable plasma6. |
