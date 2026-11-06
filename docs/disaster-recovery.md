# Disaster recovery

Plan for losing a disk, a host, the home or the VPS, or the whole site (fire, theft, ransomware). Goal: the important data survives at least two independent failures, and every host can be rebuilt from this repository plus the private repository.

## Data classes

| Class | Examples | Where it lives | Loss tolerance |
|---|---|---|---|
| A: irreplaceable | documents, photos, KeePassXC database, sops age keys, LUKS headers, PGP and SSH keys, mail | NixOS-Server1 `pool01/shares` (document, photo, jf), Stalwart on NixOS-ServerPublic, clients | none |
| B: expensive to recreate | application state (Nextcloud, Forgejo, Home Assistant, Linkwarden, HomeBox, Matrix, Monero wallet files) | `pool01/applications`, `/var/lib` on NixOS-ServerPublic | one day |
| C: replaceable | music, videos, games, Kiwix ZIMs, Ollama and ComfyUI models | `pool01/shares/{music,video,games}`, `pool01/applications/{ollama,comfyui}` | can be downloaded again |
| D: configuration | NixOS configuration, private repository | git (local, Forgejo, later a remote mirror) | none |

## Copies (3-2-1-1)

| Data | Copy 1 | Copy 2 (other medium) | Copy 3 (off-site) | Offline / immutable |
|---|---|---|---|---|
| A + B of NixOS-Server1 | ZFS pool (raid) + snapshots | Back In Time to the external disk WD2_10TB_BCK (`backup-external`) | restic to Proton Drive (encrypted before upload, `hosts/NixOS-Server1/backup.nix`) | external disk is disconnected after the backup |
| A + B of NixOS-ServerPublic | btrfs on one disk (raid1 only with a second disk) | restic to the append-only REST server on NixOS-Server1 (WireGuard) | full disk backup at the provider | append-only REST server (the VPS cannot delete its backups) |
| A + B of NixOS-ServerGaming (Minecraft worlds) | btrfs on one disk | restic to the append-only REST server on NixOS-Server1 (WireGuard) | full disk backup at the provider | append-only REST server |
| Clients | btrfs on the client | Syncthing to NixOS-Server1 / Back In Time (Desktop) | through NixOS-Server1 to Proton Drive | - |
| C (videos, music) | ZFS pool | optional: second large disk or cold storage | not covered | - |
| D | local git | Forgejo on NixOS-Server1 | TODO: second remote (Codeberg private repo or a Forgejo instance on NixOS-ServerPublic) | Portable SSD (contains the configuration) |

Videos are not part of the Proton Drive backup (size). Options for them, from cheap to safe:

1. A second large HDD in a different place (parents, office), filled every few months with `zfs send` or `rsync`, encrypted with LUKS.
2. Hetzner Storage Box BX21+ (5-10 TB, about 2-4 EUR/TB/month) with restic or `zfs send` over ssh; restic encrypts client-side.
3. Cold cloud storage (Backblaze B2, Wasabi, Scaleway Glacier ~2 EUR/TB/month) through rclone crypt or restic. Restores of cold storage are slow and can cost egress fees.
4. Accept the loss for content that can be downloaded again (keep a list of titles in the document share, which is backed up).

## Keys you need to restore anything

Keep these on paper or on two offline USB sticks (encrypted with a passphrase you can remember), stored in two places:

- sops admin age key (only in KeePassXC, entry with the URL `https://sops-admin.invalid`, plus an offline copy on paper or a USB stick), without it no secret of the private repository can be edited. Host keys (`/secrets/keys.txt`) are replaceable: a new key plus `sops updatekeys` with the admin key.
- restic repository passwords (`restic/password` of every host, they are in the sops files, but the sops files are useless without the age key).
- LUKS passphrases and the TPM2 recovery keys (`systemd-cryptenroll --recovery-key`); LUKS header backups (`cryptsetup luksHeaderBackup`) of every disk.
- KeePassXC database + key file.
- Proton account recovery phrase, Storage Box credentials, registrar and VPS account credentials (in KeePassXC).
- PGP private key (paper key, `paperkey`), SSH keys are in KeePassXC.

## Scenarios

| Scenario | Recovery |
|---|---|
| One disk of a mirror fails | Replace the disk, `zpool replace` (Server1) or `btrfs replace` (ServerPublic with two disks). |
| Client lost or broken | Install with `NixOSInstaller.sh`, copy the host age key to `/secrets/keys.txt` (or create a new one and `sops updatekeys`), restore the home data from NixOS-Server1 (Syncthing, Back In Time). |
| NixOS-Server1 lost | New machine, install the host, create the ZFS pool, restore `applications` and `shares` from the external disk (fast) or from Proton Drive (`restic -r rclone:proton:nixos-server1 restore latest --target /`). Videos only from the optional copy. |
| NixOS-ServerPublic lost | New VPS, `nixos-anywhere` (see `TODO.md`), restore `/var/lib` and the PostgreSQL dumps from the REST server on NixOS-Server1 or the full disk backup at the provider, change the DNS records to the new IP. |
| NixOS-ServerGaming lost | New VPS, `nixos-anywhere`, restore `/persistent/srv/minecraft` with restic, change the DNS records. |
| Ransomware on a client or server | The append-only REST server and the offline external disk cannot be encrypted by the attacker; ZFS snapshots are read-only. Restore from a snapshot older than the infection. Rotate all secrets afterwards. |
| Home destroyed (fire, theft) | Proton Drive (A + B of Server1), full disk backups of the VPS at the provider, the off-site copy of the keys. Rebuild the hosts from git (the Portable SSD or the remote mirror of the repository). |
| Proton account locked | The other copies stay; move the restic repository with `restic copy` to another backend. |

## Tests (every 3 months)

1. `restic check --read-data-subset=5%` for every repository (Proton Drive, REST server).
2. Restore one random directory of each class to `/tmp` and compare with `diff -r`.
3. Restore a PostgreSQL dump into a test database (VMServerPublic) and start Nextcloud against it.
4. Boot VMServer / VMServerPublic from the repository to prove the configuration still builds without the real hardware.
5. Check the age of the newest snapshot in Grafana (alert "backup older than 2 days").
6. Once a year: read the paper copy of the keys and decrypt a sops file with it.
