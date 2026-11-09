# Proton Drive

## How it is used

NixOS-Server1 backs up only irreplaceable data with restic to Proton Drive (decision 08.11.2026, the Duo plan has 2 TB): `pool01/shares/photo` completely, `pool01/shares/jf/Dokumente` (contains both NixOS repositories through Syncthing), `pool01/shares/document/Office Dokumente` and `pool01/shares/document/Wiso Mein Geld`. Every dataset is snapshotted on its own (`zfsDatasets`, subdirectories in `zfsSubdirs`). The alert `ResticRepositoryFull` fires above 1.9 TB (`sizeLimit`); after each backup `restic-size-proton` measures the repository. The data is backed up (`hosts/NixOS-Server1/backup.nix`, currently disabled until the secrets exist). restic talks to Proton Drive through rclone (backend `protondrive`, repository `rclone:proton:nixos-server1`). restic encrypts and deduplicates everything on the server before the upload: Proton only stores restic pack files, and Proton's own encryption comes on top.

## Schedule and versions

The backup runs every night at 02:00 (up to 30 minutes later), see `nixos.system.restic.time`. Every run is a restic snapshot; restic stores only what changed (deduplication), so many versions cost little space. Kept are the last 7 daily, 4 weekly and 12 monthly snapshots (`pruneOpts` in `nixosModules/system/restic.nix`), older ones are pruned after the backup. If the repository grows beyond 1.9 TB (`sizeLimit`, the Duo plan has 2 TB), `restic-size-proton` thins it out after the backup until it fits: monthly versions first (12, 9, 6, 3, 0), then weekly (4, 2, 0), then daily (7, 3, 1); the latest snapshot always stays. If it still does not fit, the alert `ResticRepositoryFull` fires. After each run `restic check --read-data-subset=2%` reads a sample of the data back.

## Restore on a client

On a client with the repository passwords (KeePassXC entries "restic repository NixOS-Server1" and "Proton"): the same steps as in the emergency below, or directly on NixOS-Server1 with the wrapper of the restic module: `sudo restic-proton snapshots`, `sudo restic-proton mount /mnt` (browse, Ctrl+C ends it), `sudo restic-proton restore latest --target /tmp/restore --include <path>`.

The Proton Drive app and website only show the encrypted restic pack files.

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

