# applications

## Purpose

Desktop applications, grouped by category.

## How it works

- `homeManager.applications.enable` enables the category bundles; inside a bundle every application can be switched on or off per host (e.g. desktop only applications in `hosts/NixOS-Desktop/home/home.nix`).

## Contents

| Path | Description |
|---|---|
| [`browser/`](browser/README.md) | Web browsers. |
| [`communication/`](communication/README.md) | Messengers, mail and voice. |
| [`development/`](development/README.md) | Development tools. |
| [`editing/`](editing/README.md) | Graphics, video, audio, CAD and 3D editing. |
| [`education/`](education/README.md) | Learning and reference applications (Kiwix, Stellarium). |
| [`gaming/`](gaming/README.md) | Game launchers and tools. |
| [`media/`](media/README.md) | Media players, recording, RSS and download tools. |
| [`office/`](office/README.md) | Office, documents, finance. |
| [`screenshot/`](screenshot/README.md) | Screenshot tools (Flameshot, Spectacle). |
| [`sync/`](sync/README.md) | Synchronisation and sharing with other devices. |
| [`terminal/`](terminal/README.md) | Terminal emulator (kitty). |
| [`tools/`](tools/README.md) | Utilities. |
| [`vpn/`](vpn/README.md) | VPN clients. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.enable` | boolean | `false` | Enable applications modules bundle. |
