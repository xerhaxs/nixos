# hyprland

## Purpose

Hyprland desktop (second session next to Plasma, selectable in SDDM) with Catppuccin theme.

## How it works

- The main configuration is Lua (`config/hyprland.lua`, Hyprland 0.56 Lua API), loaded through `wayland.windowManager.hyprland.extraLuaFiles`; monitors and touch support come from the host.
- Helper services (Waybar, SwayNC, hypridle, kanshi, hyprsunset, awww, pyprland, cliphist, polkit agent) are bound to `hyprland-session.target`, so they never start in Plasma.
- Waybar (floating islands), Rofi (launcher, calc, clipboard, bluetooth), SwayNC (notification center, Hyprland only), hyprlock + hypridle (lock, dim, screen off, suspend), wlogout with the `power-menu` wrapper, Flameshot (screenshots through the portal), awww + waypaper (wallpapers, slideshow timer), kanshi (monitor profiles), hyprsunset (blue light filter), pyprland (dropdown terminal, volume mixer, zoom), hyprtasking (workspace overview).
- `touch.enable` (Convertible, portable host): hyprgrass gestures, wvkbd on-screen keyboard (edge swipe up), iio-hyprland auto rotation.

## Contents

| Path | Description |
|---|---|
| [`config/`](config/README.md) | Lua configuration files of Hyprland. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.windowManager.hyprland.enable`. |
| `display.nix` | Enable kanshi (monitor profiles) and hyprsunset (blue light filter). |
| `hypridle.nix` | Enable hypridle (dim, lock, screen off, suspend). |
| `hyprland.nix` | Enable hyprland. |
| `hyprlock.nix` | Enable hyprlock. |
| `pyprland.nix` | Enable pyprland scratchpads (dropdown terminal, volume mixer) and zoom. |
| `rofi.nix` | Enable rofi. |
| `swaync.nix` | Enable SwayNotificationCenter. |
| `touch.nix` | Enable touchscreen support for Hyprland (gestures, on-screen keyboard, auto rotation). |
| `utilities.nix` | Enable Hyprland utilities (polkit agent, clipboard history, image viewer, color picker, media and brightness tools). |
| `wallpaper.nix` | Enable awww (swww) wallpapers with waypaper and a random slideshow. |
| `waybar.nix` | Enable waybar. |
| `wlogout.nix` | Enable wlogout, `power-menu` opens it with a fixed button size. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.windowManager.hyprland.display.enable` | boolean | `false` | Enable kanshi (monitor profiles) and hyprsunset (blue light filter). |
| `homeManager.desktop.windowManager.hyprland.enable` | boolean | `false` | Enable hyprland modules bundle. |
| `homeManager.desktop.windowManager.hyprland.hypridle.enable` | boolean | `false` | Enable hypridle (dim, lock, screen off, suspend). |
| `homeManager.desktop.windowManager.hyprland.hyprland.enable` | boolean | `false` | Enable hyprland. |
| `homeManager.desktop.windowManager.hyprland.hyprlock.enable` | boolean | `false` | Enable hyprlock. |
| `homeManager.desktop.windowManager.hyprland.pyprland.enable` | boolean | `false` | Enable pyprland scratchpads (dropdown terminal, volume mixer) and zoom. |
| `homeManager.desktop.windowManager.hyprland.rofi.enable` | boolean | `false` | Enable rofi. |
| `homeManager.desktop.windowManager.hyprland.swaync.enable` | boolean | `false` | Enable SwayNotificationCenter. |
| `homeManager.desktop.windowManager.hyprland.touch.enable` | boolean | `false` | Enable touchscreen support for Hyprland (gestures, on-screen keyboard, auto rotation). |
| `homeManager.desktop.windowManager.hyprland.utilities.enable` | boolean | `false` | Enable Hyprland utilities (polkit agent, clipboard history, image viewer, color picker, media and brightness tools). |
| `homeManager.desktop.windowManager.hyprland.wallpaper.directory` | string | `"${config.xdg.userDirs.pictures}/Desktopbilder"` | Directory with the wallpapers of the slideshow (searched recursively). |
| `homeManager.desktop.windowManager.hyprland.wallpaper.enable` | boolean | `false` | Enable awww (swww) wallpapers with waypaper and a random slideshow. |
| `homeManager.desktop.windowManager.hyprland.wallpaper.interval` | string | `"10min"` | Interval of the slideshow (systemd time span). |
| `homeManager.desktop.windowManager.hyprland.waybar.enable` | boolean | `false` | Enable waybar. |
| `homeManager.desktop.windowManager.hyprland.wlogout.enable` | boolean | `false` | Enable wlogout. |

## Notes

- Keys: Super+Return terminal, Super+R/Space launcher, Super+E Dolphin, Super+Q close, Super+F float, Super+Shift+F fullscreen, Super+M maximize, Super+Tab overview, Super+V clipboard, Super+. calculator, Super+C color picker, Super+N notifications, Super+W wallpaper, Super+L lock, Super+Shift+E power menu, Super+` dropdown terminal, Super+A volume mixer, Super+Z zoom, Print screenshot.
- Check the configuration: `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`.
- hyprgrass comes from `pkgs/hyprgrass` until nixpkgs ships a version that builds against Hyprland 0.56.
- `hypr-dynamic-cursors` is not in the plugin list: the version in nixpkgs (2026-07-21) throws during init on Hyprland 0.56.2. The settings in `config/hyprland.lua` stay and apply as soon as it is added back to `plugins`.
- Colors of Rofi, wlogout and hyprlock come from the Catppuccin palette of `config.catppuccin`, so flavor and accent apply everywhere.
- swaync is the D-Bus activator of `org.freedesktop.Notifications`. Its unit only runs with `XDG_CURRENT_DESKTOP=Hyprland`, in Plasma plasmashell keeps the name.
- Terminals are translucent only when started from Hyprland (`kitty -o background_opacity`), Plasma keeps opaque ones.
- Waybar and Rofi use Material Design glyphs (U+F0000 and up), glyphs below U+F900 got lost in `waybar.nix` before.
