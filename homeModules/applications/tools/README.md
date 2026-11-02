# tools

## Purpose

Utilities.

## How it works

- KeePassXC (with ssh-agent integration), Qalculate, GNOME Disks, Back In Time and Dangerzone.
- Back In Time: `dailyProfile` sets the profile to anacron mode, `nixos.system.cron` adds an hourly job to the system crontab, which survives the tmpfs. Back In Time runs once a day and catches up after the machine was off.
- Dangerzone converts untrusted documents to safe PDFs inside rootless podman (gVisor); the package is built from source in `pkgs/dangerzone`.

## Contents

| Path | Description |
|---|---|
| `backintime.nix` | Enable backintime |
| `dangerzone.nix` | Enable Dangerzone (needs nixos.virtualisation.podman). |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.tools.enable`. |
| `gnomedisk.nix` | Enable gnomedisk |
| `keepassxc.nix` | Enable keepassxc |
| `qalculate.nix` | Enable qalculate |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.tools.backintime.dailyProfile` | null or (positive integer, meaning >0) | `null` | Profile id which is backed up once a day. The hourly job of `nixos.system.cron` starts it, Back In Time skips it until a day has passed, so a missed backup catches up. |
| `homeManager.applications.tools.backintime.enable` | boolean | `false` | Enable backintime |
| `homeManager.applications.tools.dangerzone.enable` | boolean | `false` | Enable Dangerzone (needs nixos.virtualisation.podman). |
| `homeManager.applications.tools.enable` | boolean | `false` | Enable tools modules bundle. |
| `homeManager.applications.tools.gnomedisk.enable` | boolean | `false` | Enable gnomedisk |
| `homeManager.applications.tools.keepassxc.enable` | boolean | `false` | Enable keepassxc |
| `homeManager.applications.tools.qalculate.enable` | boolean | `false` | Enable qalculate |
