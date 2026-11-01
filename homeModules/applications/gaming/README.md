# gaming

## Purpose

Game launchers and tools.

## How it works

- Only enabled on hosts with `nixos.userEnvironment.game.enable`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.gaming.enable`. |
| `gameconqueror.nix` | Enable scanmem / gameconqueror / cheat engine. |
| `heroic.nix` | Enable heroic. |
| `lutris.nix` | Enable lutris. |
| `mangohud.nix` | Enable mangohud. |
| `prismlauncher.nix` | Enable prismlauncher. |
| `steam.nix` | Enable steam. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.gaming.enable` | boolean | `false` | Enable gaming modules bundle. |
| `homeManager.applications.gaming.gameconqueror.enable` | boolean | `false` | Enable scanmem / gameconqueror / cheat engine. |
| `homeManager.applications.gaming.heroic.enable` | boolean | `false` | Enable heroic. |
| `homeManager.applications.gaming.lutris.enable` | boolean | `false` | Enable lutris. |
| `homeManager.applications.gaming.mangohud.enable` | boolean | `false` | Enable mangohud. |
| `homeManager.applications.gaming.prismlauncher.enable` | boolean | `false` | Enable prismlauncher. |
| `homeManager.applications.gaming.steam.enable` | boolean | `false` | Enable steam. |
