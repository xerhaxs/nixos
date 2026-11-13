# temp

## Purpose

The countdown website, it runs on NixOS-ServerGaming only for testing and is removed later.

## How it works

- `default.nix` enables the module, it stays reusable in `nixosModules/`.
- Removal: delete this folder and its import in `../default.nix`, then the DNS record (see `TODO.md`, last phase).

## Contents

| Path | Description |
|---|---|
| `default.nix` | Enables the countdown website. |
