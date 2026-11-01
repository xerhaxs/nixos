# home

## Purpose

Home basics and the import of the host specific home configuration.

## How it works

- `home.nix` imports `hosts/<hostname>/home/default.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.home.enable`. |
| `home.nix` | Enable home settings. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.home.enable` | boolean | `false` | Enable home modules bundle. |
| `homeManager.home.home.enable` | boolean | `false` | Enable home settings. |
