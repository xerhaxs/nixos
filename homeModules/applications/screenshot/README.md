# screenshot

## Purpose

Screenshot tools (Flameshot, Spectacle).

## How it works

- Both are available, Flameshot runs as user service.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.screenshot.enable`. |
| `flameshot.nix` | Enable flameshot. |
| `spectacle.nix` | Enable spectacle. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.screenshot.enable` | boolean | `false` | Enable screenshot modules bundle. |
| `homeManager.applications.screenshot.flameshot.enable` | boolean | `false` | Enable flameshot. |
| `homeManager.applications.screenshot.spectacle.enable` | boolean | `false` | Enable spectacle. |
