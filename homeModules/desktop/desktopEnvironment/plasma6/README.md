# plasma6

## Purpose

KDE Plasma 6 user configuration (plasma-manager).

## How it works

- Panels, shortcuts, Dolphin, dconf settings.

## Contents

| Path | Description |
|---|---|
| `dconf.nix` | Enable dconf |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.desktop.desktopEnvironment.plasma6.enable`. |
| `dolphin.nix` | Enable dolphin. |
| `merkuro.nix` | Merkuro and the clock calendar with the calendars and tasks of Radicale only (Akonadi DAV resource with CalDAV, no time limit, no default birthday/personal calendar or address book); Akonadi database, Merkuro selection and `plasmashellrc` (calendars of the clock) persistent. |
| `plasma6.nix` | Enable plasma6. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.desktop.desktopEnvironment.plasma6.dconf.enable` | boolean | `false` | Enable dconf |
| `homeManager.desktop.desktopEnvironment.plasma6.dolphin.enable` | boolean | `false` | Enable dolphin. |
| `homeManager.desktop.desktopEnvironment.plasma6.dolphin.places` | list of (submodule) | Minecraft (`sftp://admin@NixOS-ServerGaming/srv/minecraft`), plus WebDAV (`/mount/dav`) if `nixos.userEnvironment.networkshares.webdav.enable` | Entries added to the places panel if missing (removing one in Dolphin brings it back at the next activation). |
| `homeManager.desktop.desktopEnvironment.plasma6.merkuro.enable` | boolean | `false` | Merkuro with the calendars and tasks of Radicale only (Akonadi DAV resource, CalDAV, complete history), events in the calendar of the clock; the password is asked once and kept in KWallet. |
| `homeManager.desktop.desktopEnvironment.plasma6.merkuro.url` | string | `"https://radicale.${osConfig.nixos.site.homeDomain}/"` | CalDAV address of Radicale. |
| `homeManager.desktop.desktopEnvironment.plasma6.enable` | boolean | `false` | Enable plasma6 modules bundle. |
| `homeManager.desktop.desktopEnvironment.plasma6.plasma6.enable` | boolean | `false` | Enable plasma6. |
