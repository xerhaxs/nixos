# NixOS configuration

Personal NixOS configuration based on flakes, disko, impermanence, sops-nix and Home Manager. It is tailored to my setup; reuse it as a reference and adapt it to your system.

## Structure

| Path | Description |
|---|---|
| [`flake.nix`](flake.nix) | Inputs and the list of hosts. Every host is `nixosModules` + `hosts/<host>` + `homeModules`. |
| [`nixosModules/`](nixosModules/README.md) | System modules (`options.nixos.*`), grouped by category. All implementation lives here. |
| [`homeModules/`](homeModules/README.md) | Home Manager modules (`options.homeManager.*`). |
| [`hosts/`](hosts/README.md) | One folder per host, only options. Profile (`configuration.nix`, `server.nix`) and machine (`machine.nix`, `disko.nix`, `hardware-configuration.nix`) are separated, the VM hosts reuse the profile of their model. |
| [`pkgs/`](pkgs/README.md) | Own packages (overlay): Dangerzone, hyprgrass fix, image pins (`images.json`, `nix run .#update-images`). |
| [`secrets/`](secrets/README.md) | Legacy sops file of the home hosts (to be split, see `TODO.md`). |
| [`docs/`](docs/README.md) | Background documents: disaster recovery, E2EE, isolation, VMs, offline installation, providers, mail/PGP, ... |
| `NixOSInstaller.sh` | Installer script for the live ISO. |
| [`TODO.md`](TODO.md) | Step-by-step list of the manual steps (German). |
| [`CHECKLIST.md`](CHECKLIST.md) | Acceptance checklist of all changes (German). |
| [`CLAUDE.md`](CLAUDE.md) | Context notes for Claude Code (German). |

Every folder has a `README.md` with its purpose, contents and options.

## Hosts

| Host | Role |
|---|---|
| NixOS-Desktop | Main desktop |
| NixOS-Framework, NixOS-Convertible | Laptops |
| NixOS-Portable | All-in-one installation on an external SSD (every application, boot entry `server` with the offline capable services) |
| NixOS-Server1 | Home server (ZFS pool, media, shares, Home Assistant, DNS, git, monitoring) |
| NixOS-ServerGaming | Public VPS for games (Minecraft with BlueMap, countdown website) |
| NixOS-ServerPublic | Public VPS (mail, Nextcloud, Matrix, CryptPad, Mumble, ntfy, code-server, Miniflux, Briar Mailbox), WireGuard hub |
| NixOS-VMDesktop, NixOS-VMServer, NixOS-VMServerGaming, NixOS-VMServerPublic | Test VMs with the profile of the corresponding host |

## Private repository

Domains, addresses and secrets are not part of this repository. They are in the private repository `nixos-private`, used as the flake input `private`:

- `site.nix`: domains (`domain`, `homeDomain`, `mailDomain`), contact addresses, data of NixOS-ServerPublic. Available as `config.nixos.site.*`.
- `secrets/<hostname>.yaml`: one sops file per host, only decryptable by the admin key and the key of that host (`nixos.system.sops.perHostFile = true`).

After changes in the private repository: commit there, then `nix flake update private` here. Building from the remote flake (installer, `system.autoUpgrade`) needs read access to the private repository (deploy key).

## Installation

Boot a NixOS installation medium, then:

```
sudo -i
curl -L https://raw.githubusercontent.com/xerhaxs/nixos/main/NixOSInstaller.sh | bash
```

The installer partitions with disko (LUKS2 + btrfs, tmpfs root), creates `/secrets/keyfile.key` for additional data disks and optionally stores the sops age key of the host in `/secrets/keys.txt`. The age key is only needed at activation (boot), not to build or install. Without it, secrets are missing until the key is copied, the password falls back to `initialHashedPassword`.

NixOS-ServerPublic is installed with nixos-anywhere, see `TODO.md`.

NixOS-Portable: set the disk id in `hosts/NixOS-Portable/disko.nix`, install it from any Linux with the SSD attached (`disko --mode destroy,format,mount` + `nixos-install --flake .#NixOS-Portable`). It boots on legacy BIOS (limine in the BIOS boot partition) and UEFI (removable path `EFI/BOOT/BOOTX64.EFI`, no NVRAM entry); Secure Boot has to be disabled on foreign machines. The boot menu entry with the tag `server` starts the services on `https://<service>.portable.internal` (self-signed certificate).

Desktops can start Plasma or Hyprland in SDDM; see `homeModules/desktop/windowManager/hyprland/README.md` for the Hyprland key bindings.

### Host keys for sops

```
# new key of a host
nix shell nixpkgs#age -c age-keygen -o /secrets/keys.txt
# public key, add it to nixos-private/secrets/.sops.yaml and run: sops updatekeys <hostname>.yaml
nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt
# key from an ssh private key
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt
```

### Secure Boot

1. `sudo sbctl create-keys` (stored in `/var/lib/sbctl`, persisted).
2. `nixos.system.secureboot.enable = true;`, rebuild.
3. Enable the Secure Boot setup mode in the firmware, then `sudo sbctl enroll-keys --microsoft --firmware-builtin`.
4. Check with `bootctl status`.

### TPM2 + PIN

With Secure Boot working and `nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true`:

```
systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 /dev/disk/by-partlabel/disk-NIXOS-LUKS
systemd-cryptenroll --recovery-key /dev/disk/by-partlabel/disk-NIXOS-LUKS
```

The passphrase stays as a separate key slot. If the TPM fails or the Secure Boot state changes, unlock with the passphrase and enroll again.

### Keyfile for additional data disks

```
cryptsetup luksAddKey /dev/disk/by-label/CRYPTDATA /secrets/keyfile.key
```

## Operation

```
# update inputs and rebuild
nix flake update --commit-lock-file
nixos-rebuild switch --flake .#HOSTNAME

# build on this machine, deploy to a server
nixos-rebuild switch --flake .#SERVERHOSTNAME --target-host REMOTEUSER@SERVERHOSTNAME --sudo

# firmware updates
fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update
```

New files have to be added to git (`git add`) before a rebuild, flakes ignore untracked files.

Logs of earlier boots: `journalctl -b -1 -p err` (needs the persisted `/etc/machine-id`, older journals: `journalctl -m`).

Unlock a server after a reboot: `ssh root@<host>` (NixOS-ServerPublic: port 2222), then `systemd-tty-ask-password-agent --query`.

`system.autoUpgrade` is off until the rework is merged (TODO phase 17), afterwards the servers deploy the pushed configuration nightly without automatic reboot.

## Security concept

- Disks: LUKS2 (argon2id) everywhere, impermanence (tmpfs root), Secure Boot and TPM2 + PIN on clients and NixOS-Server1, remote unlock over initrd ssh on the servers.
- Secrets: sops-nix, declared in the module that uses them, one file per host.
- System: sysctl and kernel hardening, module blacklist, hidepid, auditd (servers log every program start), sudo only for wheel, no su/sg/newgrp/sudoedit setuid wrappers, restricted nix daemon, hardened own systemd units, coredumps limited and not persisted, authenticated time (chrony with NTS), hardened malloc on NixOS-ServerPublic.
- SSH: keys only, post-quantum key exchange (mlkem768x25519), 3 attempts, verbose logging, sshguard; SSH keys can live in KeePassXC (`docs/keepassxc-ssh-agent.md`).
- Untrusted documents: Dangerzone converts them to safe PDFs in a gVisor sandbox.
- Network: firewall with only the needed ports, services behind nginx on localhost, catch-all vhost, HSTS, WireGuard for internal access (code-server, backups, monitoring, ssh of NixOS-ServerPublic), fail2ban and sshguard, recursive DNSSEC validating resolver, Pi-hole through WireGuard on the clients, DNS over TLS fallback, MAC randomization.
- Data: restic backups (append-only REST server at home, Storage Box, Proton Drive for NixOS-Server1), ZFS and btrfs snapshots before backups, ClamAV scans with alerts.
- Monitoring: Prometheus, Loki and Grafana on NixOS-Server1, alerts by mail and ntfy.
- Vulnerabilities and updates: every host scans its closure (sbomnix, grype), NixOS-Server1 compares the pins with upstream, the result is in Grafana (`docs/updates-and-vulnerabilities.md`).
- Killswitch: a Home Assistant script publishes to an ntfy topic, every host powers off immediately.

Protection while running (beyond encryption at rest, details in `docs/e2ee-and-runtime-protection.md` and `docs/isolation.md`): end-to-end encrypted services (CryptPad, Matrix, Nextcloud end-to-end encryption, Briar), Stalwart encryption at rest with the PGP/S/MIME key of the user, the killswitch, and on the VPS confidential computing (AMD SEV-SNP/Intel TDX) if the provider offers it. The provider of a VPS can still read the memory of a running VM without confidential computing.

## UnifiedPush on GrapheneOS

Push notifications without Google services, through the own ntfy server (`push.<domain>`).

1. Install ntfy (F-Droid). In the settings set the default server to `https://push.<domain>`, add your user for this server, choose WebSocket as connection protocol and allow the app to run in the background (Settings > Apps > ntfy > Battery > Unrestricted).
2. ntfy is now a UnifiedPush distributor. Apps with UnifiedPush support offer it in their notification settings.

| App | Setup |
|---|---|
| Element, SchildiChat, FluffyChat (F-Droid builds) | Settings > Notifications > method UnifiedPush/ntfy. Synapse uses ntfy as Matrix push gateway automatically. |
| Molly (Signal) | Settings > Notifications > UnifiedPush; needs MollySocket (`nixos.server.public.mollysocket`). Without MollySocket Molly can use its own websocket. |
| DAVx5 | WebDAV-Push with UnifiedPush; the server side is the Nextcloud app `dav_push`. |
| Nextcloud (F-Droid build) | UnifiedPush in the app settings, if the installed version supports it. |
| Tusky, Moshidon (Mastodon) | UnifiedPush is selected automatically when a distributor is installed. |
| Home Assistant | The companion app has no UnifiedPush; use the ntfy integration of Home Assistant and subscribe to the topic in ntfy. |
| Server alerts | Subscribe to the alert topic of `nixos.system.notify.ntfy` and the monitoring topic in ntfy. |

Apps without UnifiedPush: Signal (own websocket without Google), Telegram (own connection), Discord, Briar (Tor, uses the Briar Mailbox), Thunderbird for Android and other mail apps (IMAP IDLE).

## Credits

Thanks to https://github.com/ryan4yin/nix-config.

Useful: ids of system users/groups https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/misc/ids.nix, prefetch sources with `nix-prefetch-url --unpack <url>` or `lib.fakeHash`.
