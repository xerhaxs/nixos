# terminal

## Purpose

Terminal emulator (kitty).

## How it works

- kitty with the Catppuccin theme and own settings.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.terminal.enable`. |
| `kitty.nix` | Enable kitty. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.terminal.enable` | boolean | `false` | Enable terminal modules bundle. |
| `homeManager.applications.terminal.kitty.enable` | boolean | `false` | Enable kitty. |
