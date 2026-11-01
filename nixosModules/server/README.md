# server

## Purpose

Server applications, grouped by category. Each service has its own nginx virtual host on `<service>.<nginx.domain>` with an ACME certificate.

## How it works

- `nixos.server.dataDir` (default `/var/lib`) is the base directory of the application state, e.g. `/pool01/applications` on NixOS-Server1 or `/data/applications` with a disko data pool.
- `nixos.server.network.nginx.domain` defaults to `nixos.site.domain`; NixOS-Server1 uses `nixos.site.homeDomain`.
- Secrets are declared in the module that uses them and only exist on hosts where the module is enabled.
- Persistence entries are only added when the state is below `/var/lib` (impermanence hosts without data pool).

## Contents

| Path | Description |
|---|---|
| [`entertainment/`](entertainment/README.md) | Media server and the automated media management (Usenet). |
| [`fileshare/`](fileshare/README.md) | File shares in the home network (SMB and WebDAV). |
| [`game/`](game/README.md) | Game servers. |
| [`management/`](management/README.md) | Management, dashboards, home automation, inventory and monitoring. |
| [`network/`](network/README.md) | Network services: reverse proxy, DNS, VPN and brute force protection. |
| [`public/`](public/README.md) | Services of the public server (NixOS-ServerPublic). |
| [`sync/`](sync/README.md) | Synchronisation and storage services: git, bookmarks, calendars and backups. |
| [`tools/`](tools/README.md) | Web tools, private frontends and local AI. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.enable`. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.dataDir` | string | `"/var/lib"` | Base directory for the state of server applications (<dataDir>/<service>). |
| `nixos.server.enable` | boolean | `false` | Enable server modules bundle. |
