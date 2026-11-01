# hosts

## Purpose

One folder per host. Hosts only set options of the modules, there is no implementation here.

## How it works

- `default.nix` imports the files of the host; the flake builds every folder listed in `flake.nix`.
- Real hosts separate the profile (`configuration.nix`, `server.nix`, `home/home.nix`: what runs on the host) from the machine (`machine.nix`, `hardware-configuration.nix`, `disko.nix`, `networking.nix`: hardware, disks, addresses, passwords).
- The VM hosts import the profile of their model and only bring VM hardware and one disk, so they behave like the real host.
- `home/` contains the user settings of the host and is imported by `homeModules/home/home.nix`.

## Contents

| Path | Description |
|---|---|
| [`NixOS-Convertible/`](NixOS-Convertible/README.md) | Convertible laptop (Intel), Plasma 6, sops wifi, private DNS, MAC randomization, TPM2. |
| [`NixOS-Desktop/`](NixOS-Desktop/README.md) | Main desktop (AMD), Plasma 6, additional data disks (`mount.nix`), Back In Time daily backup, TPM2. |
| [`NixOS-Framework/`](NixOS-Framework/README.md) | Framework laptop (AMD), Plasma 6, sops wifi, private DNS, MAC randomization, TPM2. |
| [`NixOS-Portable/`](NixOS-Portable/README.md) | Portable all-in-one installation on one external SSD: every application, hybrid BIOS/UEFI boot, LUKS, impermanence; boot entry `server` starts the offline capable server services on `*.portable.internal`. |
| [`NixOS-Server1/`](NixOS-Server1/README.md) | Home server with ZFS pool `pool01`: media, file shares, Home Assistant, DNS, git, monitoring, Monero node, HomeBox. Application state on `/pool01/applications`. |
| [`NixOS-ServerGaming/`](NixOS-ServerGaming/README.md) | Public VPS for games: Minecraft with BlueMap, countdown website; backups to NixOS-Server1 and a Storage Box. |
| [`NixOS-ServerPublic/`](NixOS-ServerPublic/README.md) | Public VPS: mail, Nextcloud, Matrix, CryptPad, Mumble, ntfy, code-server, Miniflux, Briar Mailbox; WireGuard hub; backups to NixOS-Server1 and a Storage Box. |
| [`NixOS-VMDesktop/`](NixOS-VMDesktop/README.md) | Virtual machine with the profile of NixOS-Desktop. |
| [`NixOS-VMServer/`](NixOS-VMServer/README.md) | Virtual machine with the profile of NixOS-Server1 (without ZFS pool, devices and backups). |
| [`NixOS-VMServerGaming/`](NixOS-VMServerGaming/README.md) | Virtual machine with the profile of NixOS-ServerGaming (without WireGuard identity and backups, uses the secrets of NixOS-ServerGaming). |
| [`NixOS-VMServerPublic/`](NixOS-VMServerPublic/README.md) | Virtual machine with the profile of NixOS-ServerPublic (without WireGuard identity and backups, uses the secrets of NixOS-ServerPublic). |
