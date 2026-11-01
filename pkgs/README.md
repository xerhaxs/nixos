# pkgs

## Purpose

Own packages, added to nixpkgs as overlay in `flake.nix` (also `nix build .#dangerzone`).

## How it works

- `dangerzone`: Dangerzone built from the source release (no package in nixpkgs).
- `hyprgrass`: the hyprgrass commit pinned upstream for Hyprland 0.56.2, remove it after a nixpkgs update.
- Sources come from the flake inputs `dangerzone`, `hyprgrass-src` and `wf-touch-src`, the hashes are in `flake.lock`.

## Contents

| Path | Description |
|---|---|
| [`dangerzone/`](dangerzone/README.md) | Dangerzone built from source. |
| [`hyprgrass/`](hyprgrass/README.md) | hyprgrass (touch gestures for Hyprland) at the commit that builds against Hyprland 0.56.2. |
| `default.nix` | Overlay that adds the own packages, the sources are flake inputs. |
| `images.json` | Container images with digest, the only pins outside of `flake.lock`. |
| `update-images.nix` | `nix run .#update-images` updates `images.json`, `--check` only compares. |
