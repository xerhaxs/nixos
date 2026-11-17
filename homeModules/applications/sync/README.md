# sync

## Purpose

Synchronisation and sharing with other devices.

## How it works

- KDE Connect, OnionShare and rclone.
- `proton-backup`: browse and restore the restic backup of NixOS-Server1 on Proton Drive. `proton-backup setup` logs in once (2FA code); the rclone config keeps only the session tokens (rclone renews them) and is encrypted with the restic passphrase, which comes from KeePassXC (entry with the URL `https://restic-proton.invalid`). `proton-backup` mounts all versions read-only in `~/ProtonBackup`, any other argument is passed to restic (`snapshots`, `restore`, …). Enabled with KeePassXC.
- `syncthing.nix` only persists the Syncthing configuration, the service itself is `nixosModules/userEnvironment/syncthing.nix`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.sync.enable`. |
| `kdeconnect.nix` | Enable kdeconnect sync. |
| `onionshare.nix` | Enable onionshare sync. |
| `proton-backup.nix` | Command `proton-backup` for the restic backup on Proton Drive. |
| `rclone.nix` | Enable rclone sync. |
| `syncthing.nix` | Enable syncthing |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.sync.enable` | boolean | `false` | Enable sync modules bundle. |
| `homeManager.applications.sync.kdeconnect.enable` | boolean | `false` | Enable kdeconnect sync. |
| `homeManager.applications.sync.onionshare.enable` | boolean | `false` | Enable onionshare sync. |
| `homeManager.applications.sync.protonBackup.enable` | boolean | `false` | Command proton-backup to browse and restore the restic backup of NixOS-Server1 on Proton Drive (read only, passphrase from KeePassXC). |
| `homeManager.applications.sync.protonBackup.keepassxcHost` | string | `"restic-proton.invalid"` | Host of the URL (https://<host>) of the KeePassXC entry with the restic passphrase. |
| `homeManager.applications.sync.protonBackup.mountPoint` | string | `"${config.home.homeDirectory}/ProtonBackup"` | Where proton-backup mount shows the snapshots. |
| `homeManager.applications.sync.protonBackup.repository` | string | `"rclone:proton:nixos-server1"` | restic repository of the backup. |
| `homeManager.applications.sync.rclone.enable` | boolean | `false` | Enable rclone sync. |
| `homeManager.applications.sync.syncthing.enable` | boolean | `false` | Enable syncthing |
