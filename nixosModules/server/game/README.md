# game

## Purpose

Game servers.

## How it works

- `minecraft.nix` provides the infrastructure of nix-minecraft and common `serverProperties`; the server instances (whitelist, motd, ports, JVM heap) are defined in the host, e.g. `hosts/NixOS-ServerPublic/minecraft.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.game.enable`. |
| `minecraft.nix` | Enable Minecraft Server. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.game.enable` | boolean | `false` | Enable game modules bundle. |
| `nixos.server.game.minecraft.enable` | boolean | `false` | Enable Minecraft Server. |
| `nixos.server.game.minecraft.serverProperties` | attribute set of anything | `{   accepts-transfers = false;   allow-flight = true;   a...` | Common server.properties for all instances, merged with the instance specific values in the host. |

## Notes

- Server console: `tmux -S /run/minecraft/<server>.sock attach`.
- https://github.com/Infinidoge/nix-minecraft
