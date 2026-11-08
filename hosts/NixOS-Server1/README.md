# NixOS-Server1

## Purpose

Home server with ZFS pool `pool01`: media, file shares, Home Assistant, DNS, git, monitoring, Monero node, HomeBox. Application state on `/pool01/applications`.

## How it works

- `default.nix` imports the files below. See `hosts/README.md` for the separation of profile and machine.
- Installation and maintenance: [`README.md`](../../README.md#installation), host specific steps in [its section](../../README.md#nixos-server1).

## Contents

| Path | Description |
|---|---|
| [`home/`](home/README.md) | User (Home Manager) settings of this host. |
| `backintime.nix` | Back In Time configuration for the local backup disk. |
| `backup.nix` | restic backups of this host. |
| `configuration.nix` | Profile: user name, desktop/server role and the general settings shared with the VM of this host. |
| `default.nix` | Imports of the host files. |
| `disko.nix` | Disk layout selection (`nixos.disko.*`, disks, swap size, data pool). |
| `hardware-configuration.nix` | Generated hardware configuration (kernel modules for the hardware). |
| `homeassistant.nix` | Home Assistant devices and the Thread border router of this machine. |
| `machine.nix` | Machine: state version, password fallback, hardware modules, Secure Boot, TPM2, initrd ssh and machine specific paths. |
| `networking.nix` | Hostname, addresses, LAN and DNS options. |
| `server.nix` | Enabled server services (on NixOS-Portable: the `server` specialisation). |
| `services.nix` | Ordering of the services after the ZFS pool, bind mounts and the PostgreSQL location. |
| `syncthing.nix` | Syncthing server with devices and folders. |
| `usergroupids.nix` | Fixed user and group ids (matching the files on the ZFS pool). |
| `zfsmount.nix` | ZFS pool import, key loading from sops, scrub and trim. |
