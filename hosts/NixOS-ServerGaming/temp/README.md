# temp

## Purpose

Services that run on NixOS-ServerGaming only for testing and are removed later: Nextcloud with Collabora, Mumble, code-server and the countdown website.

## How it works

- `default.nix` enables the modules, they stay reusable in `nixosModules/`.
- Removal: delete this folder and its import in `../default.nix`, then the DNS records and the firewall rules in the Contabo panel (see `TODO.md`, last phase). The data of Nextcloud stays in `/persistent/var/lib/nextcloud` and the PostgreSQL database until it is deleted by hand.
- Nextcloud Talk has no TURN server here, coturn runs on NixOS-ServerPublic and its secret is not shared.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Enables the test services and the countdown. |
