# theme

## Purpose

User theme (Catppuccin).

## How it works

- Uses the accent and flavor of the NixOS theme.

## Contents

| Path | Description |
|---|---|
| `catppuccin.nix` | Enable catppuccin theme. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.theme.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.theme.catppuccin.enable` | boolean | `false` | Enable catppuccin theme. |
| `homeManager.theme.enable` | boolean | `false` | Enable theme modules bundle. |
