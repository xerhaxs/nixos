# End-to-end encryption and protection while running

## The problem

LUKS protects the data only while the machine is off (or the disk is removed). While NixOS-ServerPublic runs, the disks are unlocked: everybody who controls the running system can read the data in clear text. That includes an attacker who exploits a web service, and the VPS provider (it can read the RAM and the unlocked disk of the VM). Nextcloud stores files unencrypted on the server by default, and its server-side encryption keeps the keys on the same server, so it does not help against this threat.

Data is only protected against a compromised server if it is encrypted on the clients and the server never sees the keys (end-to-end encryption).

## What already is end-to-end encrypted

| Service | Status |
|---|---|
| CryptPad | Documents are encrypted in the browser, the server only stores ciphertext. |
| Matrix (Element) | Rooms with encryption enabled (default for direct messages). The bridges decrypt messages on the server (needed to forward them to Signal/WhatsApp). |
| Briar Mailbox | Only stores encrypted messages for the Briar app. |
| Stalwart | Encryption at rest with your OpenPGP or S/MIME key: incoming mail is encrypted with your public key before it is stored. The server cannot read stored mail afterwards (it can read mail while it is being received). |
| Nextcloud end-to-end encryption app | Folder-level E2EE, only for folders you mark, only in the desktop and mobile clients (not in the web UI, not with Nextcloud Office, no sharing to the web). Usable for a few sensitive folders, known to be fragile. |

## Options for files and photos

| Option | What it is | Pros | Cons |
|---|---|---|---|
| Ente Photos (self-hosted, `services.ente` in nixpkgs) | E2EE photo and video library with apps for Android/iOS/desktop/web, face and object search on the device | Real E2EE, very good apps, automatic phone backup, sharing links stay E2EE, open source (server "museum" + web apps), NixOS module exists | Needs S3 object storage (Garage or MinIO on the same host, or external), 5 subdomains, PostgreSQL; only photos and videos; the self-hosted server needs the free plan limits lifted manually (`ente admin update-subscription`); another service to maintain |
| Ente Auth | E2EE 2FA (TOTP) app with sync | Replaces Aegis + manual export, sync through the own Ente server | Same server needs; Aegis (local only) is simpler and safer if you do not need sync |
| Cryptomator vault in Nextcloud/WebDAV | Client-side encrypted folder (files and names), apps for Linux, Android (paid), iOS | Works with any storage (Nextcloud, WebDAV, Proton Drive), no server change | Desktop app needed (cryptomator in nixpkgs), no web access, no server-side preview or search |
| gocryptfs / rclone crypt | Client-side encrypted directory or remote | Simple, scriptable, rclone crypt also works on Android (Round Sync) | No GUI sharing, conflicts with sync clients if used wrong |
| Syncthing with an untrusted device | NixOS-ServerPublic as "untrusted" Syncthing device: it stores only encrypted data, the password lives on the clients | Server never sees plaintext, uses the existing Syncthing setup, good off-site copy | No web access, no sharing; an encrypted folder can only be read on trusted devices |
| Nextcloud E2EE app | see above | Already installed | Folder-level only, fragile |

Recommendation:

1. Photos from the phone: Ente Photos on NixOS-ServerPublic with Garage as local S3 storage (both have NixOS modules). It replaces the photo upload of the Nextcloud app and is the only option with real E2EE and good apps. If you want it, it can be added as `nixos.server.public.ente` (TODO).
2. Sensitive documents: a Cryptomator vault inside Nextcloud (or the Nextcloud E2EE app for a few folders).
3. Off-site copy of the home data to the VPS: Syncthing with NixOS-ServerPublic as untrusted device instead of plaintext folders.
4. Keep Nextcloud for things that need the server to read them (calendar, contacts, Collabora office, shares with other people).

## Protection while running (beyond E2EE)

- Killswitch (Home Assistant button -> ntfy -> every host powers off, the disks lock).
- Confidential computing at the VPS provider (AMD SEV-SNP or Intel TDX): RAM is encrypted against the hypervisor. Few providers offer it for small VMs (Azure, Google, OVH bare metal, some Hetzner dedicated), check before choosing a provider (see `providers.md`).
- Isolation of the exposed services so one exploited service does not see the data of the others: see `isolation.md`.
- Minimize what the server keeps: short log retention, no plaintext backups (restic encrypts), mail encryption at rest in Stalwart.
