# desktop

## Purpose

User side of the desktop: Plasma, Hyprland, xdg and X settings.

## How it works

- Enabled when the NixOS desktop is enabled.

## Contents

| Path | Description |
|---|---|
| [`desktopEnvironment/`](desktopEnvironment/README.md) | Desktop environment user settings. |
| [`windowManager/`](windowManager/README.md) | Window manager user settings. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.enable`. |
| `favorites.nix` | Favorite applications, shared by the Plasma task bar and the Hyprland launcher. |
| `xdg.nix` | Enable xdg settings. |
| `xserver.nix` | Enable xserver settings. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.enable` | boolean | `false` | Enable desktop modules bundle. |
| `homeManager.desktop.favorites` | list of string | The applications of the Plasma task bar. | Desktop entry ids (without `.desktop`) of the favorite applications, shared by the Plasma task bar and the Hyprland launcher. |
| `homeManager.desktop.xdg.enable` | boolean | `false` | Enable xdg settings. |
| `homeManager.desktop.xserver.enable` | boolean | `false` | Enable xserver settings. |
