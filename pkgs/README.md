# pkgs

## Purpose

Own packages, added to nixpkgs as overlay in `flake.nix` (also `nix build .#dangerzone`).

## How it works

- `dangerzone`: Dangerzone built from the source release (no package in nixpkgs).
- `hyprgrass`: the hyprgrass commit pinned upstream for Hyprland 0.56.2, remove it after a nixpkgs update.

## Contents

| Path | Description |
|---|---|
| [`dangerzone/`](dangerzone/README.md) | Dangerzone built from source. |
| [`hyprgrass/`](hyprgrass/README.md) | hyprgrass (touch gestures for Hyprland) at the commit that builds against Hyprland 0.56.2. |
| `default.nix` | Overlay that adds the own packages. |
