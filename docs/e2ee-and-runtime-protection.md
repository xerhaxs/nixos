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
| Cryptomator vault | Client-side encrypted folder (files and names) inside any synced or shared folder, apps for Linux, Android (paid), iOS | Works with Syncthing, SMB, WebDAV, Proton Drive, no server change | Desktop app needed (cryptomator in nixpkgs), no web access, no server-side preview or search |
| gocryptfs / rclone crypt | Client-side encrypted directory or remote | Simple, scriptable, rclone crypt also works on Android (Round Sync) | No GUI sharing, conflicts with sync clients if used wrong |
| Nextcloud E2EE app | see above | Comes with Nextcloud | Folder-level only, fragile |

Decision (08.11.2026): photos and files stay on NixOS-Server1 (LUKS and encrypted ZFS, Syncthing and SMB), no E2EE photo service and no Syncthing copy on the VPS. They are protected while the server is off; a compromised running NixOS-Server1 could read them. For single sensitive folders a Cryptomator vault inside the synced folder is the simplest addition.

## Protection while running (beyond E2EE)

- Killswitch (Home Assistant button -> ntfy -> every host powers off, the disks lock).
- Confidential computing at the VPS provider (AMD SEV-SNP or Intel TDX): RAM is encrypted against the hypervisor. Few providers offer it for small VMs (Azure, Google, OVH bare metal, some Hetzner dedicated), check before choosing a provider (see `providers.md`).
- Isolation of the exposed services: systemd sandboxing per service (`systemd-analyze security` scores 1 to 2 for most services on NixOS-ServerPublic, the bridges and ntfy were tightened on 08.11.2026). NixOS containers or micro VMs were considered and not chosen: with one kernel they add little over the sandboxing, nested virtualisation on the VPS is slow.
- Minimize what the server keeps: short log retention, no plaintext backups (restic encrypts), mail encryption at rest in Stalwart.
