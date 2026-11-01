# Proton Drive

## How it is used

NixOS-Server1 backs up `pool01/applications` and `pool01/shares` (without `video`) with restic to Proton Drive (`hosts/NixOS-Server1/backup.nix`, currently disabled until the secrets exist). restic talks to Proton Drive through rclone (backend `protondrive`, repository `rclone:proton:nixos-server1`). restic encrypts and deduplicates everything on the server before the upload: Proton only stores restic pack files, and Proton's own encryption comes on top.

## Access from the phone

The Proton Drive app shows only the encrypted restic pack files, not the original files. Options:

| Need | Way |
|---|---|
| Restore a few files in an emergency | Termux on Android: `pkg install restic rclone`, copy the rclone config (with the Proton login) and the restic password, then `restic -r rclone:proton:nixos-server1 ls latest` and `restic restore latest --include <path> --target ~/restore`. Needs Proton two-factor login once. |
| Browse files on the phone regularly | Not with restic. Use a separate folder: either normal files in Proton Drive (Proton's E2EE, readable in the Proton app) or an rclone `crypt` remote on top of Proton Drive, readable with Round Sync (rclone for Android). |
| Photos | Ente Photos or the Proton Drive photo backup, see `e2ee-and-runtime-protection.md`. |

Round Sync (Android, based on rclone) can open Proton Drive and rclone crypt remotes. Users report that the Proton login in the app fails sometimes; the workaround is to create the rclone config with `rclone config` on the PC or in Termux and import it into Round Sync. Large files (over a few GB) are reported to fail, restic packs are small, so this does not affect restores.

Keep the restic password and the rclone config in KeePassXC; without the restic password the backup is unreadable (see `disaster-recovery.md`).
