# sync

## Purpose

Synchronisation and sharing with other devices.

## How it works

- KDE Connect, OnionShare and rclone.
- `syncthing.nix` only persists the Syncthing configuration, the service itself is `nixosModules/userEnvironment/syncthing.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.sync.enable`. |
| `kdeconnect.nix` | Enable kdeconnect sync. |
| `onionshare.nix` | Enable onionshare sync. |
| `rclone.nix` | Enable rclone sync. |
| `syncthing.nix` | Enable syncthing |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.sync.enable` | boolean | `false` | Enable sync modules bundle. |
| `homeManager.applications.sync.kdeconnect.enable` | boolean | `false` | Enable kdeconnect sync. |
| `homeManager.applications.sync.onionshare.enable` | boolean | `false` | Enable onionshare sync. |
| `homeManager.applications.sync.rclone.enable` | boolean | `false` | Enable rclone sync. |
| `homeManager.applications.sync.syncthing.enable` | boolean | `false` | Enable syncthing |
