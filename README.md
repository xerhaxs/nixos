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
| [`docs/`](docs/README.md) | Background documents: disaster recovery, E2EE, offline installation, providers, mail/PGP, ... |
| `NixOSInstaller.sh` | Installer script for the live ISO, to be rebuilt for the offline installation image (`TODO.md` 15.3). |
| [`TODO.md`](TODO.md) | Step-by-step list of the manual steps (German). |
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

After changes in the private repository: commit there, then `nix flake update private` here. The private repository is not published: every host is built and deployed from a client that has it (see Installation and Maintenance).

## Installation

Every host is installed the same way: prepare it in the private repository, start a target system, install it from an existing client with nixos-anywhere, unlock it, then finish the host specific steps. The client builds the system; the target only needs network and SSH. Everything on the target disk is lost.

| Host | Target system | Unlock at boot | Host specific steps |
|---|---|---|---|
| NixOS-Desktop, NixOS-Framework, NixOS-Convertible | NixOS ISO on the machine | passphrase at the console, later TPM2 + PIN | [Clients](#clients) |
| NixOS-Server1 | NixOS ISO on the machine | initrd ssh (port 22) or TPM2 + PIN | [NixOS-Server1](#nixos-server1) |
| NixOS-ServerPublic, NixOS-ServerGaming | Debian from the Contabo panel | initrd ssh (port 2222) | [VPS](#vps) |
| NixOS-Portable | the SSD attached to any Linux | passphrase at the console | [NixOS-Portable](#nixos-portable) |
| NixOS-VM* | not installed | – | [Test VMs](#test-vms) |

In the commands, `<host>` is the host name (`NixOS-Server1`), `<ip>` its address, `<file>` its sops file: `clients.yaml` for Desktop, Framework and Convertible, `nixos-<host in lower case>.yaml` for all others.

### Requirements on the client

- Both repositories: `~/Documents/nixos` (this one) and `~/Documents/nixos-private` (flake input `private`, the path is fixed in `flake.nix`).
- KeePassXC unlocked. Its SSH agent holds the key of the client, sops gets the admin key from it (one-time setup per client: `kpxc-cred configure`, see [Host keys for sops](#host-keys-for-sops)).
- Entries for the new host in KeePassXC: `LUKS <host>` (disk passphrase), `Login <host>` (password of `jf` on clients and Portable, of `admin` on servers), `age <host>` (sops key, step 2 below). Generate the passphrase and the login password in KeePassXC before they are used anywhere.

### 1. Prepare the host

1. Hardware: `hosts/<host>/disko.nix` names the disk (`_module.args.disks`), `hardware-configuration.nix` the kernel modules. For new hardware, generate it from the target system (step 2 below): `ssh <user>@<ip> nixos-generate-config --show-hardware-config --no-filesystems > hosts/<host>/hardware-configuration.nix`. New files have to be added with `git add` (flakes ignore untracked files).
2. VPS only: in `nixos-private/site.nix` under `serverPublic` or `serverGaming` the values `ipv4`, `ipv4Gateway`, `ipv4PrefixLength`, `ipv6` and `ipv6PrefixLength` from the Contabo panel. `hosts/vps-uplink.nix` builds the static address of the system and of the initrd from them.
3. sops key of the host (skip on a reinstall, the key in `age <host>` stays valid):

   ```
   cd /run/user/1000
   nix shell nixpkgs#age -c age-keygen -o keys.txt
   ```

   Put the line `AGE-SECRET-KEY-1…` into the password field of `age <host>` and the public key into its notes, then delete the file: `shred -u keys.txt`. Add the public key to `nixos-private/secrets/.sops.yaml` (rule of `<file>`) and re-encrypt: `cd ~/Documents/nixos-private/secrets && sops updatekeys -y <file>`.
4. Login password as hash in sops (`<user>` is `jf` or `admin`, see above):

   ```
   cd ~/Documents/nixos-private/secrets
   h=$(nix shell nixpkgs#mkpasswd -c mkpasswd -m sha-512 -R 500000) && printf '"%s"' "$h" | sops set --value-stdin <file> '["user"]["<host in lower case>"]["<user>"]'; unset h
   ```

5. All other secrets of the host: `sops <file>`. Every module declares the secrets it needs, the build fails when one is missing.
6. Commit and build:

   ```
   cd ~/Documents/nixos-private && git add -A && git commit -m "<host>"
   cd ~/Documents/nixos && nix flake update private
   nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel
   ```

   A missing secret stops the build with `the key '…' cannot be found`.

### 2. Start the target system

Physical machines (Desktop, laptops, Server1):

1. Disable Secure Boot in the firmware (it is enabled again after the installation), boot the NixOS minimal ISO in UEFI mode.
2. Connect the network (cable, or `nmtui` for wifi), set a password for the live user with `passwd`, start SSH with `sudo systemctl start sshd` (the ISO does not start it by itself), show the address with `ip -4 addr`.
3. On the client: `ssh-keygen -R <ip>`, `ssh-copy-id nixos@<ip>`, then `ssh nixos@<ip> lsblk -o NAME,SIZE,TYPE,MODEL`. The disk must match `hosts/<host>/disko.nix`.

The user for the next steps is `nixos` (nixos-anywhere uses its sudo).

VPS (Contabo):

1. Firewall: Customer Panel, Network Services, Firewall, one firewall per server with Accept rules, source "Any", each rule once for IPv4 and once for IPv6, assigned to the VPS. Before the installation only 22 and 2222 (TCP). After the installation:

   | Host | Ports |
   |---|---|
   | NixOS-ServerPublic | 80, 443, 25, 465, 587, 993 (TCP); 3478, 5349 (TCP and UDP); 49152-49999 (UDP, TURN relay); 51820 (UDP, WireGuard); ICMP |
   | NixOS-ServerGaming | 80, 443, 25565 (TCP); ICMP |

   Ports 22 (SSH) and 2222 (initrd ssh) stay open, SSH does not depend on WireGuard.
2. Customer Panel, Servers & Hosting, VPS/VDS, "Install" (or "More", "Reinstall"): Standard Image Debian, the SSH public key of the client (`cat ~/.ssh/id_ed25519.pub`), a throwaway root password. On a VPS that is already installed, the Rescue System with the same SSH key works as well.
3. On the client: `ssh-keygen -R <ip>`, then `ssh root@<ip> 'lsblk -o NAME,SIZE,TYPE,MODEL; ls /sys/firmware/efi; ip -4 addr; ip -4 route; ip -6 addr'`. Contabo uses `/dev/sda` and legacy BIOS (`/sys/firmware/efi` does not exist), `hosts/<host>/disko.nix` is set up for that (`biosBoot = true`, `nixos.system.bootloader.biosDevice = "/dev/sda"`, `removable = true`). Address, prefix and gateway must match `site.nix`, otherwise neither SSH nor the disk unlock answers after the installation.

The user for the next steps is `root`.

### 3. Install

Prepare the files in RAM (`/run/user/1000` is a tmpfs, nothing is written to a disk):

```
d=$(mktemp -d -p /run/user/1000 anywhere.XXXXXX)
mkdir -p "$d"/extra/{secrets,persistent/etc/ssh}
chmod 755 "$d"/extra "$d"/extra/persistent "$d"/extra/persistent/etc "$d"/extra/persistent/etc/ssh
chmod 700 "$d"/extra/secrets

# sops key: paste the line AGE-SECRET-KEY-1... from "age <host>", Enter, Ctrl+D
(umask 077; cat > "$d"/extra/secrets/keys.txt)

# disk passphrase from "LUKS <host>", without a trailing newline (it is typed at boot)
(umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > "$d"/luks.pass); echo
```

Hosts with initrd ssh (Server1, ServerPublic, ServerGaming) also get the host key of the initrd:

```
ssh-keygen -q -t ed25519 -N "" -C "initrd@<host>" -f "$d"/extra/persistent/etc/ssh/initrd_host_key
ssh-keygen -lf "$d"/extra/persistent/etc/ssh/initrd_host_key.pub
```

Note the fingerprint in the notes of `LUKS <host>`, it is compared at every unlock.

Hosts whose data disks are unlocked with `/secrets/keyfile.key` (the disks in `hosts/NixOS-Desktop/mount.nix`, hosts with `dataPool.enable`): on a reinstall save the existing key file from the attachment of `LUKS <host>` as `"$d"/extra/secrets/keyfile.key` (`chmod 400`). On a new installation with `dataPool.enable`, create one with `(umask 077; openssl rand -out "$d"/extra/secrets/keyfile.key 4096)`, add `--disk-encryption-keys /tmp/keyfile.key "$d"/extra/secrets/keyfile.key` to the command below and attach the file to `LUKS <host>`.

Install:

```
cd ~/Documents/nixos
nix run nixpkgs#nixos-anywhere -- --flake .#<host> \
  --disk-encryption-keys /tmp/secret.key "$d"/luks.pass \
  --extra-files "$d"/extra \
  <user>@<ip> 2>&1 | tee /run/user/1000/anywhere.log
```

The path `/tmp/secret.key` is fixed in `nixosModules/disko/disko-luks-btrfs-tmpfs.nix`, the passphrase is only used to format and is not stored. On Debian, nixos-anywhere first switches to its installer in RAM (kexec). If GitHub fails to serve the kexec tarball (HTTP 504), build it locally and add it: `k=$(nix build --no-link --print-out-paths github:nix-community/nixos-images#kexec-installer-nixos-stable-noninteractive)`, then `--kexec "$k"/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz`. At the end the target reboots.

### 4. Unlock, check, clean up

1. Unlock:
   - At the console (clients, Portable, Server1 without ssh): type the passphrase.
   - Through initrd ssh (servers; port 22 on Server1, 2222 on the VPS):

     ```
     ssh-keygen -R <ip>; ssh-keygen -R "[<ip>]:<port>"
     ssh -p <port> root@<ip>
     systemd-tty-ask-password-agent
     ```

     Compare the fingerprint with the one in `LUKS <host>`, then paste the passphrase. The session ends when the boot continues. On a VPS without answer, use the VNC console in the Contabo panel.
2. Check with the user of the host (`jf` or `admin`, new host key, accept it):

   ```
   ssh-keygen -R <ip>
   ssh -t <user>@<ip> 'sudo -v && systemctl --failed --no-legend; sudo nix shell nixpkgs#age -c age-keygen -y /secrets/keys.txt; ls /etc/ssh /persistent/etc/ssh'
   ```

   `sudo` takes the password of `Login <host>`, no unit has failed, the public key matches `.sops.yaml`, `/etc/ssh` contains `sshd_config`, `/persistent/etc/ssh` the host keys (and `initrd_host_key`). On clients also `systemctl status home-manager-jf`. Note the fingerprint of the host key (`ssh-keygen -lf /persistent/etc/ssh/ssh_host_ed25519_key.pub`) in `Login <host>`.
3. Reboot once (`sudo reboot`), unlock again. The login must work without a host key warning, which shows that the persistence holds.
4. Clean up on the client: `shred -u "$d"/luks.pass "$d"/extra/secrets/* "$d"/extra/persistent/etc/ssh/* 2>/dev/null; rm -r "$d" /run/user/1000/anywhere.log`. Delete the throwaway root password of the Debian system.

### 5. Host specific steps

#### Clients

1. Log in as `jf`. Syncthing brings `~/Documents` (both repositories and the KeePassXC database) from NixOS-Server1, its device identity comes from sops.
2. Unlock KeePassXC. The SSH key of this client (entry `SSH id_ed25519 <host>`) is added to the agent, check with `ssh-add -l`. Run `kpxc-cred configure` once for sops and git.
3. Secure Boot (keys in `/var/lib/sbctl`, persisted; limine creates them at the first bootloader installation):
   1. `sudo sbctl status` shows the keys. If not: `sudo sbctl create-keys && sudo nixos-rebuild boot --flake .#<host>`.
   2. In the firmware: reset Secure Boot to setup mode, boot.
   3. `sudo sbctl enroll-keys --microsoft --firmware-builtin`, reboot, enable Secure Boot in the firmware.
   4. `sudo sbctl status` shows "Secure Boot: enabled".
4. TPM2 + PIN (with `nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true`, only after Secure Boot works):

   ```
   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes --tpm2-pcrs=7 /dev/disk/by-partlabel/disk-NIXOS-LUKS
   sudo systemd-cryptenroll --recovery-key /dev/disk/by-partlabel/disk-NIXOS-LUKS
   ```

   Store the PIN and the recovery key (attribute `recovery key`, protected) in `LUKS <host>`. The passphrase stays as a separate key slot. If the TPM fails or the Secure Boot state changes, unlock with the passphrase and enroll again.
5. NixOS-Desktop with new data disks: add the key file to each of them (asks for the passphrase of the disk), then attach `/secrets/keyfile.key` to `LUKS <host>`:

   ```
   sudo cryptsetup luksAddKey /dev/disk/by-label/CRYPTDATA /secrets/keyfile.key
   sudo cryptsetup luksAddKey /dev/disk/by-label/CRYPTGAMES /secrets/keyfile.key
   sudo cryptsetup luksAddKey /dev/disk/by-label/CRYPTBACKUP /secrets/keyfile.key
   ```

6. Check: `systemctl --failed` and `systemctl --user --failed` are empty, Plasma has its panels and theme.

#### NixOS-Server1

1. Secure Boot and TPM2 + PIN at the console, as for the clients (steps 3 and 4). initrd ssh stays available for remote unlocks.
2. ZFS: the pool `pool01` is not touched by the installation. `zfs-load-keys` imports it (fixed `networking.hostId`), loads the keys from the sops secret `zfs/pool01` and mounts the datasets, services with data on the pool wait for `zfs-mounts-ready`. Check: `zpool status pool01`, `systemctl status zfs-mounts-ready`, `systemctl --failed`.
3. Mullvad logs in with the account from sops, the device stays in the persisted `/etc/mullvad-vpn`. Check: `mullvad status`.

#### VPS

1. Open the remaining firewall ports (table in step 2).
2. DNS in Cloudflare, every entry "DNS only", A and AAAA to the addresses of the VPS:
   - NixOS-ServerPublic: `matrix` (Matrix ids are `@name:matrix.<domain>`, the apex needs no record), `turn`, `mail`, `stalwart`, `mta-sts`, `autoconfig`, `autodiscover`, `cryptpad`, `cryptpad-sandbox`, `rss`, `push`, and `openpgpkey` once a PGP key is set. The mail records (MX, SPF, DKIM, DMARC, TLS-RPT, SRV) are shown by Stalwart for the domain ("View DNS records"). MTA-STS needs a TXT record `_mta-sts` with `v=STSv1; id=<date>`, Stalwart serves the policy itself; change the id whenever the policy changes.
   - NixOS-ServerGaming: `bluemap`, `flolserver`, `countdown`, and the test services in `temp/` (`cloud`, `office`, `code`).
3. NixOS-ServerPublic: reverse DNS of both addresses to `mail.<domain>` (Contabo Customer Panel, Reverse DNS Management).
4. Accounts in the services: admin and personal account are always separate, see the notes in [`nixosModules/server/public/README.md`](nixosModules/server/public/README.md).
5. WireGuard: set the public key of the host in `nixosModules/system/wireguard.nix` and deploy the hub first, then the host. The tunnel carries backups, monitoring and internal services, SSH stays reachable directly.

#### NixOS-Portable

Install from any Linux with the SSD attached and both repositories present:

```
lsblk -o NAME,SIZE,MODEL,SERIAL                # find the SSD, set its id in hosts/NixOS-Portable/disko.nix
(umask 077; read -rsp "LUKS passphrase: " p; printf '%s' "$p" > /tmp/secret.key); echo
cd ~/Documents/nixos
sudo nix run github:nix-community/disko -- --mode destroy,format,mount --flake .#NixOS-Portable
sudo install -m 400 -o root -D /dev/stdin /mnt/secrets/keys.txt    # paste the line from "age NixOS-Portable", Enter, Ctrl+D
sudo nixos-install --no-root-passwd --flake .#NixOS-Portable
shred -u /tmp/secret.key
```

It boots on legacy BIOS (limine in the BIOS boot partition) and UEFI (removable path `EFI/BOOT/BOOTX64.EFI`, no NVRAM entry). Secure Boot has to be disabled on foreign machines. The boot menu entry with the tag `server` starts the services on `https://<service>.portable.internal` (self-signed certificate).

#### Test VMs

`nixos-rebuild build-vm --flake .#NixOS-VMServerPublic`, then `./result/bin/run-NixOS-VMServerPublic-vm` (likewise for the other VM hosts). The VMs have no sops key: services with secrets fail, the login uses `initialHashedPasswords` from `site.nix`.

#### Installer script

`NixOSInstaller.sh` is meant for installing without a second machine. Today it installs `github:xerhaxs/nixos/main`, which cannot reach the private repository, so it does not work for these hosts. It will be rebuilt to install from a locally built offline image that contains the systems of all hosts and the private input (`TODO.md` 15.3, `docs/offline-installation.md`). Until then use nixos-anywhere as described above, it stays the recommended way.

### Host keys for sops

Every host decrypts only its own file of `nixos-private/secrets/` (`nixos.system.sops.file`): one per server and for the portable SSD, `clients.yaml` for Desktop, Framework and Convertible. Only that file is copied to the host. The key of the host is `/secrets/keys.txt`, backed up in KeePassXC as `age <host>` (the line `AGE-SECRET-KEY-1…` as password, the public key in the notes). It is only needed at activation (boot), not to build or install. Without it, secrets are missing until the key is copied.

The admin key exists only in KeePassXC (entry with the URL `https://sops-admin.invalid`). `sops` gets it through `SOPS_AGE_KEY_CMD` and `git-credential-keepassxc` while the database is unlocked, like the SSH keys. One-time setup per client: `kpxc-cred configure`. The `age <host>` entries must not have that URL: KeePassXC returns the first entry with a matching URL, sops would get a host key instead of the admin key and fail with "identity did not match any of the recipients".

Copy the key to an installed host (lost or replaced key): `ssh -t <user>@<host> 'sudo install -m 400 -o root -D /dev/stdin /secrets/keys.txt'`, paste the line, Ctrl+D, then `sudo /run/current-system/activate` or reboot. A new key needs `.sops.yaml` and `sops updatekeys -y <file>` first.

SSH needs nothing after a reinstall of a client: Home Manager writes `~/.ssh/id_ed25519.pub` from `nixos.system.ssh.authorizedKeys`, the private key comes from KeePassXC once the database is unlocked. If the key is lost: generate a new one, replace it in `nixos.system.ssh.authorizedKeys`, deploy all servers.

## Maintenance

### Updates and deploys

```
cd ~/Documents/nixos
nix flake update --commit-lock-file                 # all inputs
nix flake update private                            # after a commit in the private repository

# build every host before deploying
for h in NixOS-Desktop NixOS-Framework NixOS-Convertible NixOS-Portable NixOS-Server1 NixOS-ServerPublic NixOS-ServerGaming; do
  nix build --no-link .#nixosConfigurations.$h.config.system.build.toplevel && echo "OK $h"
done

# client, on the client itself
sudo nixos-rebuild switch --flake .#<host>

# server, it builds itself because it rejects unsigned paths
nixos-rebuild switch --flake .#<host> --build-host admin@<host> --target-host admin@<host> --sudo --ask-sudo-password
```

- Use `boot` instead of `switch` when the kernel, the initrd or the boot loader change, then reboot.
- Before a deploy that touches SSH, the network or WireGuard, keep a second SSH session to the server open. Roll back with `sudo nixos-rebuild switch --rollback` or by choosing the previous generation in the boot menu.
- The VPS are reached by name on their public addresses (`networking.hosts` from `site.nix`), NixOS-Server1 in the LAN or through WireGuard. Before the clients know the names, use the address.
- New `.nix` files have to be added with `git add` before a build.
- After a deploy: `systemctl --failed` on the host.
- There is no automatic upgrade. Servers and clients are updated by hand as above (`nix flake update`, build all hosts, deploy); after kernel updates reboot and unlock the servers.

### Secrets

1. Create or change the value in KeePassXC first.
2. Change it in the service if the service stores it itself (database, router, provider).
3. `cd ~/Documents/nixos-private/secrets && sops <file>`, commit the private repository, `nix flake update private` here, deploy every host that uses the value. A changed secret restarts its unit (`restartUnits`).
4. Check the service, then delete the old value.

Never change a restic repository password only in sops: add the new key with `restic key add`, check it, remove the old one with `restic key remove <id>`, then change sops.

### Unlock after a reboot

- Servers: `ssh -p <port> root@<host>` (port 22 on NixOS-Server1, 2222 on the VPS), then `systemd-tty-ask-password-agent`. NixOS-Server1 also unlocks with TPM2 + PIN at the console.
- Clients: TPM2 PIN or passphrase at the console.

### Logs

- Current boot: `journalctl -b -p err`, earlier boot: `journalctl -b -1 -p err` (needs the persisted `/etc/machine-id`, older journals: `journalctl -m`).
- Crashes: `coredumpctl list -S today`.
- Home Manager on clients: `systemctl status home-manager-jf`. If it failed, all links in the home are missing at once.

### Firmware

```
fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update
```

### Backups

- restic: every server backs up nightly (ServerPublic and ServerGaming to the rest-server on NixOS-Server1, NixOS-Server1 to Proton Drive). Check with `systemctl status restic-backups-home` on the host (`systemctl list-units 'restic-backups-*'` lists all repositories).
- Back In Time: daily on NixOS-Desktop, on demand for the external disk of NixOS-Server1 (below).
- ZFS snapshots on NixOS-Server1: daily (7), weekly (4) and monthly (3) of every dataset with `com.sun:auto-snapshot=true` (set once on `pool01`, inherited). Restore single files from `/pool01/<dataset>/.zfs/snapshot/<name>/`, list them with `zfs list -t snapshot -r pool01`. Snapshots keep deleted and replaced files, watch the free space (`zfs list -o name,used,usedbysnapshots,avail -r pool01`).
- The repositories reach an off-site copy through the Proton Drive backup of NixOS-Server1 (Syncthing puts them into `pool01/shares/jf`).
- Restore tests and offline copies of the keys: [`docs/disaster-recovery.md`](docs/disaster-recovery.md).

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
- Network: firewall with only the needed ports, services behind nginx on localhost, catch-all vhost, HSTS, WireGuard for internal access (code-server, backups, monitoring), fail2ban and sshguard, recursive DNSSEC validating resolver, Pi-hole through WireGuard on the clients, DNS over TLS fallback, MAC randomization.
- Data: restic backups (append-only REST server at home, Proton Drive for NixOS-Server1), ZFS and btrfs snapshots before backups, ClamAV scans with alerts.
- Monitoring: Prometheus, Loki and Grafana on NixOS-Server1, alerts by mail and ntfy.
- Vulnerabilities and updates: every host scans its closure (sbomnix, grype), NixOS-Server1 compares the pins with upstream, the result is in Grafana (`docs/updates-and-vulnerabilities.md`).
- Killswitch: a Home Assistant script publishes to an ntfy topic, every host powers off immediately.

Protection while running (beyond encryption at rest, details in `docs/e2ee-and-runtime-protection.md`): end-to-end encrypted services (CryptPad, Matrix, Nextcloud end-to-end encryption, Briar), Stalwart encryption at rest with the PGP/S/MIME key of the user, the killswitch, and on the VPS confidential computing (AMD SEV-SNP/Intel TDX) if the provider offers it. The provider of a VPS can still read the memory of a running VM without confidential computing.

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
