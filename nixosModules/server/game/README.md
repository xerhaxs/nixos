# game

## Purpose

Game servers.

## How it works

- `countdown.nix`: static countdown website on `countdown.<domain>`, date and texts are options set in the host.
- `minecraft.nix` provides the infrastructure of nix-minecraft and common `serverProperties`; the server instances (whitelist, motd, ports, JVM heap) are defined in the host, e.g. `hosts/NixOS-ServerPublic/minecraft.nix`.

## Contents

| Path | Description |
|---|---|
| `countdown.html` | Page of the countdown (`@title@`, `@subtitle@`, `@target@`, `@doneText@` are replaced). |
| `countdown.nix` | Enable the countdown website on countdown.<domain>. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.game.enable`. |
| `minecraft.nix` | Enable Minecraft Server. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.game.countdown.doneText` | string |  | Headline shown when the countdown has ended. |
| `nixos.server.game.countdown.enable` | boolean | `false` | Enable the countdown website on countdown.<domain>. |
| `nixos.server.game.countdown.subtitle` | string | `""` | Line below the headline. |
| `nixos.server.game.countdown.target` | string matching the ISO 8601 pattern |  | End of the countdown (ISO 8601 with time zone). |
| `nixos.server.game.countdown.title` | string |  | Headline of the page. |
| `nixos.server.game.enable` | boolean | `false` | Enable game modules bundle. |
| `nixos.server.game.minecraft.enable` | boolean | `false` | Enable Minecraft Server. |
| `nixos.server.game.minecraft.serverProperties` | attribute set of anything | `{   accepts-transfers = false;   allow-flight = true;   a...` | Common server.properties for all instances, merged with the instance specific values in the host. |

## Notes

- BlueMap and Fabric API are pinned as flake inputs and linked into `mods/` of the instance in the host, the map is on `bluemap.<domain>`.
- Server console: `tmux -S /run/minecraft/<server>.sock attach`.
- https://github.com/Infinidoge/nix-minecraft
