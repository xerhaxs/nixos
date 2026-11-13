# sync

## Purpose

Synchronisation and storage services: git, bookmarks, calendars and backups.

## How it works

- Forgejo (git), Linkwarden (bookmarks with archive) and Radicale (CalDAV/CardDAV).

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.sync.enable`. |
| `forgejo.nix` | Enable forgejo. |
| `linkwarden.nix` | Enable linkwarden server. |
| `radicale.nix` | Enable Radicale. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.sync.enable` | boolean | `false` | Enable sync modules bundle. |
| `nixos.server.sync.forgejo.enable` | boolean | `false` | Enable forgejo. |
| `nixos.server.sync.linkwarden.enable` | boolean | `false` | Enable linkwarden server. |
| `nixos.server.sync.radicale.enable` | boolean | `false` | Enable Radicale. |
