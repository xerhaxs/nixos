# Proton Drive

## How it is used

NixOS-Server1 backs up only irreplaceable data with restic to Proton Drive (decision 08.11.2026, the Duo plan has 2 TB): `pool01/shares/photo` completely, `pool01/shares/jf/Dokumente` (contains both NixOS repositories through Syncthing), `pool01/shares/document/Office Dokumente` and `pool01/shares/document/Wiso Mein Geld`. Every dataset is snapshotted on its own (`zfsDatasets`, subdirectories in `zfsSubdirs`). The alert `ResticRepositoryFull` fires above 1.9 TB (`sizeLimit`); after each backup `restic-size-proton` measures the repository. The data is backed up (`hosts/NixOS-Server1/backup.nix`, currently disabled until the secrets exist). restic talks to Proton Drive through rclone (backend `protondrive`, repository `rclone:proton:nixos-server1`). restic encrypts and deduplicates everything on the server before the upload: Proton only stores restic pack files, and Proton's own encryption comes on top.

## Access from the phone

The Proton Drive app shows only the encrypted restic pack files, not the original files. Options:

| Need | Way |
|---|---|
| Restore a few files in an emergency | Termux on Android: `pkg install restic rclone`, copy the rclone config (with the Proton login) and the restic password, then `restic -r rclone:proton:nixos-server1 ls latest` and `restic restore latest --include <path> --target ~/restore`. Needs Proton two-factor login once. |
| Browse files on the phone regularly | Not with restic. Use a separate folder: either normal files in Proton Drive (Proton's E2EE, readable in the Proton app) or an rclone `crypt` remote on top of Proton Drive, readable with Round Sync (rclone for Android). |
| Photos | Syncthing to NixOS-Server1 (decision 08.11.2026), alternatively the Proton Drive photo backup of the Proton app. |

Round Sync (Android, based on rclone) can open Proton Drive and rclone crypt remotes. Users report that the Proton login in the app fails sometimes; the workaround is to create the rclone config with `rclone config` on the PC or in Termux and import it into Round Sync. Large files (over a few GB) are reported to fail, restic packs are small, so this does not affect restores.

Keep the restic password and the rclone config in KeePassXC; without the restic password the backup is unreadable (see `disaster-recovery.md`).

## Emergency access without any own device

Everything at home is lost or broken and you want your data back. Proton cannot read it, restic encrypted it before the upload. You need three things, nothing has to be prepared on the device:

1. The Proton login: mail address, password and a 2FA code (or one of the Proton recovery codes from the paper sheet, see `disaster-recovery.md`).
2. The password of the restic repository (the one you chose for `restic/password` of NixOS-Server1).
3. A computer with internet (Linux, macOS or Windows) or an Android phone with Termux.

On a computer: download restic (https://github.com/restic/restic/releases) and rclone (https://rclone.org/downloads/), both are single programs without installation. Then:

```
rclone config                                        # n, name "proton", storage "protondrive", your Proton login and 2FA code
rclone lsd proton:                                   # shows the folder nixos-server1
restic -r rclone:proton:nixos-server1 snapshots      # asks for the restic password, lists all backups
restic -r rclone:proton:nixos-server1 mount ~/backup # Linux and macOS: browse ~/backup/snapshots/latest/ in the file manager, Ctrl+C ends it
restic -r rclone:proton:nixos-server1 restore latest --target ~/restore --include "/pool01/shares/jf/.zfs/snapshot/restic-proton/Dokumente"
```

The paths in the backup start with `/pool01/shares/<dataset>/.zfs/snapshot/restic-proton/`, followed by the usual folders. On Windows there is no `mount`: use `restore`, or the graphical Restic Browser (https://github.com/emuell/restic-browser), which opens restic repositories and needs the same two passwords.

On an Android phone: install Termux from F-Droid, `pkg install restic rclone`, `termux-setup-storage` (access to the phone storage), then the same `rclone config` and `restic … restore … --target ~/storage/downloads/restore`. Browsing with `mount` does not work on Android.

After the emergency: delete the rclone config on the borrowed device (`rclone config delete proton`), it contains your Proton login.

