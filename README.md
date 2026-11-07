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
| NixOS-ServerGaming | Public VPS for games (Minecraft with BlueMap), test services in `temp/` (countdown, Nextcloud, code-server) |
| NixOS-ServerPublic | Public VPS (mail, Matrix, CryptPad, ntfy, Miniflux, Briar Mailbox), WireGuard hub |
| NixOS-VMDesktop, NixOS-VMServer1, NixOS-VMServerGaming, NixOS-VMServerPublic | Test VMs with the profile of the corresponding host |

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

The installer partitions with disko (LUKS2 + btrfs, tmpfs root), creates `/secrets/keyfile.key` for additional data disks (it unlocks only those, the system disk has just the passphrase) and optionally stores the sops age key of the host in `/secrets/keys.txt`. The age key is only needed at activation (boot), not to build or install. Without it, secrets are missing until the key is copied, the password falls back to `initialHashedPassword`.

NixOS-ServerPublic and NixOS-ServerGaming are installed with nixos-anywhere, see "Installing a VPS with nixos-anywhere" below.

NixOS-Portable: set the disk id in `hosts/NixOS-Portable/disko.nix`, install it from any Linux with the SSD attached (`disko --mode destroy,format,mount` + `nixos-install --flake .#NixOS-Portable`). It boots on legacy BIOS (limine in the BIOS boot partition) and UEFI (removable path `EFI/BOOT/BOOTX64.EFI`, no NVRAM entry); Secure Boot has to be disabled on foreign machines. The boot menu entry with the tag `server` starts the services on `https://<service>.portable.internal` (self-signed certificate).

Desktops can start Plasma or Hyprland in SDDM; see `homeModules/desktop/windowManager/hyprland/README.md` for the Hyprland key bindings.

### Installing a VPS with nixos-anywhere

For NixOS-ServerPublic and NixOS-ServerGaming (Contabo). nixos-anywhere connects to any running Linux as `root`, switches it to a NixOS installer in RAM (kexec), partitions the disk with disko, copies extra files and installs. Everything on the disk is lost.

Before the first installation, once per host:

- Host age key: `age <host>` in KeePassXC, public key in `nixos-private/secrets/.sops.yaml`, file re-encrypted (`sops updatekeys -y <file>.yaml`), private repository committed, `nix flake update private`.
- Firewall in the Contabo panel with at least ports 22 and 2222 (initrd ssh).
- Disk and firmware: Contabo VPS use `/dev/sda` and legacy BIOS (no `/sys/firmware/efi`). `hosts/<host>/disko.nix` then sets `biosBoot = true` and `nixos.system.bootloader` with `biosDevice = "/dev/sda"`, `biosPartitionIndex = 1` and `removable = true` (no EFI variables). Check with `lsblk` and `ls /sys/firmware/efi` in the system from the next step.
- Network: `hosts/vps-uplink.nix` builds the static address of the system and of the initrd (`nixos.system.initrdssh.ip`) from `ipv4`, `ipv4Gateway` and `ipv4PrefixLength` of the host in `$PRIV/site.nix`. They must match the VPS (`ip -4 addr` and `ip -4 route` in the system from the next step), otherwise neither SSH nor the disk unlock in the initrd answers.

1. Start a temporary system: Customer Panel, Servers & Hosting, VPS/VDS, "Install" (or "More", "Reinstall"), Standard Image Debian, add the SSH public key of the desktop (`cat ~/.ssh/id_ed25519.pub`), set a throwaway root password. Then on the desktop: `ssh-keygen -R <ipv4>` and `ssh root@<ipv4> true` (accept the fingerprint).

2. Prepare the files in RAM (`/run/user/1000` is a tmpfs, nothing is written to a disk):

   ```
   d=$(mktemp -d -p /run/user/1000 anywhere.XXXXXX)
   mkdir -p "$d"/extra/{secrets,etc/ssh,persistent/etc/ssh}
   chmod 755 "$d"/extra "$d"/extra/etc "$d"/extra/etc/ssh "$d"/extra/persistent "$d"/extra/persistent/etc "$d"/extra/persistent/etc/ssh
   chmod 700 "$d"/extra/secrets

   # host age key: paste the line AGE-SECRET-KEY-1... from "age <host>", then Ctrl+D
   (umask 077; cat > "$d"/extra/secrets/keys.txt)

   # LUKS passphrase from "LUKS <host>", without a trailing newline (it is typed at boot)
   (umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > "$d"/luks.pass); echo

   # initrd ssh host key, in both places: the installation reads /etc/ssh, after the first boot
   # /etc/ssh comes from /persistent
   ssh-keygen -q -t ed25519 -N "" -C "initrd@<host>" -f "$d"/extra/etc/ssh/initrd_host_key
   cp -p "$d"/extra/etc/ssh/initrd_host_key* "$d"/extra/persistent/etc/ssh/
   ssh-keygen -lf "$d"/extra/etc/ssh/initrd_host_key.pub
   ```

   Note the fingerprint of the initrd key in the KeePassXC entry "LUKS <host>".

3. Install from the repository:

   ```
   cd ~/Documents/nixos
   nix run nixpkgs#nixos-anywhere -- --flake .#<host> \
     --disk-encryption-keys /tmp/secret.key "$d"/luks.pass \
     --extra-files "$d"/extra \
     root@<ipv4>
   ```

   The path `/tmp/secret.key` is fixed in `nixosModules/disko/disko-luks-btrfs-tmpfs.nix`. A key file (`/tmp/keyfile.key`, kept as `/secrets/keyfile.key`) is only needed with `dataPool.enable`: the data disks are unlocked with it after the system disk, pass it with a second `--disk-encryption-keys /tmp/keyfile.key <file>` and put a copy into `extra/secrets/keyfile.key`. The system is built on the desktop and copied. At the end the VPS reboots.

4. Unlock the disk (after every reboot):

   ```
   ssh-keygen -R <ipv4>; ssh-keygen -R "[<ipv4>]:2222"
   ssh -p 2222 root@<ipv4>
   systemd-tty-ask-password-agent
   ```

   Compare the fingerprint with the one in KeePassXC, then paste the passphrase. The session ends when the boot continues. If initrd ssh does not answer, use the VNC console in the Contabo panel.

5. Check: `ssh admin@<ipv4>` (new host key, accept it), then `systemctl --failed` is empty, `sudo nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt` shows the public key from `.sops.yaml`, `ls -l /etc/ssh/initrd_host_key` exists.

6. Clean up: `shred -u "$d"/luks.pass "$d"/extra/secrets/* "$d"/extra/etc/ssh/* "$d"/extra/persistent/etc/ssh/* && rm -r "$d"`.

Later deploys: `nixos-rebuild switch --flake .#<host> --build-host admin@<ipv4> --target-host admin@<ipv4> --sudo --ask-sudo-password`, by name through WireGuard once the tunnel is up.

### Host keys for sops

Every host decrypts only its own file of `nixos-private/secrets/` (`nixos.system.sops.file`): one per server and for the portable SSD, `clients.yaml` for Desktop, Framework and Convertible. Only that file is copied to the host. Each host has its own key, generated on the host:

```
sudo nix shell nixpkgs#age -c age-keygen -o /secrets/keys.txt
# public key, add it to nixos-private/secrets/.sops.yaml and run: sops updatekeys -y <file>.yaml
sudo nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt
```

The admin key exists only in KeePassXC (entry with the URL `https://sops-admin.invalid`). `sops` gets it through `SOPS_AGE_KEY_CMD` and `git-credential-keepassxc` while the database is unlocked, like the SSH keys. One-time setup per client: `kpxc-cred configure`.

Every host key is backed up in KeePassXC as entry `age <host>` (the line `AGE-SECRET-KEY-1…` as password, the public key in the notes). These entries must not have the URL `https://sops-admin.invalid`: KeePassXC returns the first entry with a matching URL, sops would get a host key instead of the admin key and fail with "identity did not match any of the recipients".

### Reinstalling a host with its existing key

The sops file stays encrypted for the same key, nothing has to be re-encrypted. Take the key line from the KeePassXC entry `age <host>`:

- Installer (`NixOSInstaller.sh`): paste it at "Paste the sops age key of this host", it ends up in `/mnt/secrets/keys.txt` (mode 0400, root).
- nixos-anywhere (ServerPublic, ServerGaming): put it into the directory given to `--extra-files`: `mkdir -p extra/secrets && (umask 077 && cat > extra/secrets/keys.txt)`, paste the line, Ctrl+D, then `nixos-anywhere ... --extra-files extra`. Delete `extra/` afterwards (`shred -u extra/secrets/keys.txt`).
- Manual install (Portable): before the first boot `sudo install -m 400 -o root -D /dev/stdin /mnt/secrets/keys.txt`, paste the line, Ctrl+D.
- Copy to an already installed host: `ssh -t <host> 'sudo install -m 400 -o root -D /dev/stdin /secrets/keys.txt'`, paste the line, Ctrl+D, then reboot or run the activation again (`sudo /run/current-system/activate`), sops-nix installs the secrets during activation.

Check after the first boot: `sudo age-keygen -y /secrets/keys.txt` shows the public key of the host in `.sops.yaml`, `systemctl --failed` is empty.

SSH needs nothing after a reinstall of a client: Home Manager writes `~/.ssh/id_ed25519.pub` from `nixos.system.ssh.authorizedKeys`, the private key comes from KeePassXC (SSH agent) once the database is unlocked. If the key is lost: generate a new one as above, replace it in `.sops.yaml`, `sops updatekeys -y <file>.yaml` (admin key from KeePassXC), commit, `nix flake update private`, deploy.

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

# deploy to a server, it builds itself because it rejects unsigned paths
nixos-rebuild switch --flake .#SERVERHOSTNAME --build-host REMOTEUSER@SERVERHOSTNAME --target-host REMOTEUSER@SERVERHOSTNAME --sudo --ask-sudo-password

# firmware updates
fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update
```

New files have to be added to git (`git add`) before a rebuild, flakes ignore untracked files.

Logs of earlier boots: `journalctl -b -1 -p err` (needs the persisted `/etc/machine-id`, older journals: `journalctl -m`).

Unlock a server after a reboot: `ssh root@<host>` (NixOS-ServerPublic: port 2222), then `systemd-tty-ask-password-agent --query`.

`system.autoUpgrade` is off until the rework is merged (TODO phase 17), afterwards the servers deploy the pushed configuration nightly without automatic reboot.

### Back In Time on the external disk of NixOS-Server1

Plug in the disk and run this on NixOS-Server1. The script asks for the LUKS passphrase of the disk, mounts it, takes a snapshot and unmounts it again.

```bash
sudo backup-external            # uses /dev/sdi1
sudo backup-external /dev/sdX1  # other device, check with lsblk
```

Follow the log in a second terminal:

```bash
sudo tail -f /root/.local/share/backintime/takesnapshot_.log
```

Manually, if the script is not available:

```bash
sudo cryptsetup open /dev/sdi1 WD2_10TB_BCK
sudo mkdir -p /mnt/WD2_10TB_BCK
sudo mount /dev/mapper/WD2_10TB_BCK /mnt/WD2_10TB_BCK
sudo backintime --config /etc/backintime/config backup
sudo umount /mnt/WD2_10TB_BCK
sudo cryptsetup close WD2_10TB_BCK
```

## Security concept

- Disks: LUKS2 (argon2id) everywhere, impermanence (tmpfs root), Secure Boot and TPM2 + PIN on clients and NixOS-Server1, remote unlock over initrd ssh on the servers.
- Secrets: sops-nix, declared in the module that uses them, one file per host.
- System: sysctl and kernel hardening, module blacklist, hidepid, auditd (servers log every program start), sudo only for wheel, no su/sg/newgrp/sudoedit setuid wrappers, restricted nix daemon, hardened own systemd units, coredumps limited and not persisted, authenticated time (chrony with NTS), hardened malloc on NixOS-ServerPublic.
- SSH: keys only, post-quantum key exchange (mlkem768x25519), 3 attempts, verbose logging, sshguard; SSH keys can live in KeePassXC (`docs/keepassxc-ssh-agent.md`).
- Untrusted documents: Dangerzone converts them to safe PDFs in a gVisor sandbox.
- Network: firewall with only the needed ports, services behind nginx on localhost, catch-all vhost, HSTS, WireGuard for internal access (code-server, backups, monitoring, ssh of NixOS-ServerPublic), fail2ban and sshguard, recursive DNSSEC validating resolver, Pi-hole through WireGuard on the clients, DNS over TLS fallback, MAC randomization.
- Data: restic backups (append-only REST server at home, Proton Drive for NixOS-Server1), ZFS and btrfs snapshots before backups, ClamAV scans with alerts.
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
