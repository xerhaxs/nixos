# config

## Purpose

Lua configuration files of Hyprland.

## How it works

- `hyprland.lua`: look and feel, animations, keybinds, window and layer rules, plugin settings.
- `touch.lua`: hyprgrass gestures, only loaded with `touch.enable`.
- `eww.yuck`: desktop widgets, `widgets.nix` puts the variables and polls in front of it.
- `eww-popups.yuck`: popups, `popups.nix` puts the variables and polls in front of it.

## Contents

| Path | Description |
|---|---|
| `eww.yuck` | Desktop widgets of `widgets.nix`. |
| `eww-popups.yuck` | Popups of `popups.nix`. |
| `hyprland.lua` | Lua configuration file. |
| `touch.lua` | Lua configuration file. |
