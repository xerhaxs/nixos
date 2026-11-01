# game

## Purpose

Gaming: Steam, Gamemode and Gamescope.

## How it works

- Steam with Proton, Gamemode for CPU/GPU boost, Gamescope as game compositor.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.userEnvironment.game.enable`. |
| `gamemode.nix` | Enable gamemode. |
| `gamescope.nix` | Enable gamescope. |
| `steam.nix` | Enable steam. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.userEnvironment.game.enable` | boolean | `false` | Enable game modules bundle. |
| `nixos.userEnvironment.game.gamemode.enable` | boolean | `false` | Enable gamemode. |
| `nixos.userEnvironment.game.gamescope.enable` | boolean | `false` | Enable gamescope. |
| `nixos.userEnvironment.game.steam.enable` | boolean | `false` | Enable steam. |
