# entertainment

## Purpose

Media server and the automated media management (Usenet).

## How it works

- Jellyfin streams the media, Sonarr/Radarr/Lidarr/Readarr manage series, movies, music and books, SABnzbd downloads and NZBHydra2 searches the indexers.
- The services share the group `share` to access `nixos.server.fileshare.share.path`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.entertainment.enable`. |
| `jellyfin.nix` | Enable Jellyfin. |
| `lidarr.nix` | Enable Lidarr. |
| `nzbhydra2.nix` | Enable NZBHydra2. |
| `radarr.nix` | Enable Radarr. |
| `readarr.nix` | Enable Readarr. |
| `sabnzbd.nix` | Enable SABnzbd. |
| `sonarr.nix` | Enable Sonarr. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.entertainment.enable` | boolean | `false` | Enable entertainment modules bundle. |
| `nixos.server.entertainment.jellyfin.enable` | boolean | `false` | Enable Jellyfin. |
| `nixos.server.entertainment.lidarr.enable` | boolean | `false` | Enable Lidarr. |
| `nixos.server.entertainment.nzbhydra2.enable` | boolean | `false` | Enable NZBHydra2. |
| `nixos.server.entertainment.radarr.enable` | boolean | `false` | Enable Radarr. |
| `nixos.server.entertainment.readarr.enable` | boolean | `false` | Enable Readarr. |
| `nixos.server.entertainment.sabnzbd.enable` | boolean | `false` | Enable SABnzbd. |
| `nixos.server.entertainment.sonarr.enable` | boolean | `false` | Enable Sonarr. |
