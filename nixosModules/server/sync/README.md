# sync

## Purpose

Synchronisation and storage services: git, bookmarks, calendars and backups.

## How it works

- Forgejo (git), Linkwarden (bookmarks with archive), Radicale (CalDAV/CardDAV) and the restic REST server (append-only backup target, only reachable through WireGuard).

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.sync.enable`. |
| `forgejo.nix` | Enable forgejo. |
| `linkwarden.nix` | Enable linkwarden server. |
| `radicale.nix` | Enable Radicale. |
| `resticserver.nix` | Enable restic REST server. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.sync.enable` | boolean | `false` | Enable sync modules bundle. |
| `nixos.server.sync.forgejo.enable` | boolean | `false` | Enable forgejo. |
| `nixos.server.sync.linkwarden.enable` | boolean | `false` | Enable linkwarden server. |
| `nixos.server.sync.radicale.enable` | boolean | `false` | Enable Radicale. |
| `nixos.server.sync.resticserver.enable` | boolean | `false` | Enable restic REST server. |
| `nixos.server.sync.resticserver.listenAddress` | string | `"10.100.0.2"` | Address the REST server listens on (WireGuard IP of this host). |
| `nixos.server.sync.resticserver.port` | 16 bit unsigned integer; between 0 and 65535 (both inclusive) | `8000` | Port of the REST server. |
