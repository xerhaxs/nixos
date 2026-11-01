# tools

## Purpose

Utilities.

## How it works

- KeePassXC (with ssh-agent integration), Qalculate, GNOME Disks, Back In Time and Dangerzone.
- Back In Time: `dailyProfile` creates a systemd user timer for a daily backup (the crontab of Back In Time is not persistent on impermanence hosts).
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
| `homeManager.applications.tools.backintime.dailyProfile` | null or (positive integer, meaning >0) | `null` | Profile id which is backed up daily by a systemd user timer (instead of the non persistent crontab). |
| `homeManager.applications.tools.backintime.enable` | boolean | `false` | Enable backintime |
| `homeManager.applications.tools.dangerzone.enable` | boolean | `false` | Enable Dangerzone (needs nixos.virtualisation.podman). |
| `homeManager.applications.tools.enable` | boolean | `false` | Enable tools modules bundle. |
| `homeManager.applications.tools.gnomedisk.enable` | boolean | `false` | Enable gnomedisk |
| `homeManager.applications.tools.keepassxc.enable` | boolean | `false` | Enable keepassxc |
| `homeManager.applications.tools.qalculate.enable` | boolean | `false` | Enable qalculate |
