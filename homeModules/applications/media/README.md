# media

## Purpose

Media players, recording, RSS and download tools.

## How it works

- mpv, VLC, Clementine, FreeTube, Fluent Reader, OBS Studio, FFmpeg, yt-dlp, Gwenview.
- EasyEffects is not part of the bundle, only NixOS-Desktop enables it (the microphone is connected there). It loads the microphone chain `easyeffects-microphone.json` for a Rode Procaster on a Behringer UMC22 as input preset (`docs/microphone.md`).
- Fluent Reader is prefilled with the Miniflux sync of NixOS-ServerPublic (`rss.<domain>`, API key entered once in the app).

## Contents

| Path | Description |
|---|---|
| `clementine.nix` | Enable clementine. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.media.enable`. |
| `easyeffects-microphone.json` | Preset loaded by the module of the same folder. |
| `easyeffects.nix` | Enable easyeffects |
| `ffmpeg.nix` | Enable ffmpeg. |
| `fluentreader.nix` | Enable Fluent Reader (RSS reader, synced with Miniflux). |
| `freetube.nix` | Enable freetube |
| `gwenview.nix` | Enable gwenview. |
| `mpv.nix` | Enable mpv. |
| `obs-studio.nix` | Enable OBS Studio with Plugins. |
| `vlc.nix` | Enable vlc. |
| `yt-dlp.nix` | Enable yt-dlp. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.media.clementine.enable` | boolean | `false` | Enable clementine. |
| `homeManager.applications.media.easyeffects.enable` | boolean | `false` | Enable easyeffects |
| `homeManager.applications.media.enable` | boolean | `false` | Enable media modules bundle. |
| `homeManager.applications.media.ffmpeg.enable` | boolean | `false` | Enable ffmpeg. |
| `homeManager.applications.media.fluentreader.enable` | boolean | `false` | Enable Fluent Reader (RSS reader, synced with Miniflux). |
| `homeManager.applications.media.freetube.enable` | boolean | `false` | Enable freetube |
| `homeManager.applications.media.gwenview.enable` | boolean | `false` | Enable gwenview. |
| `homeManager.applications.media.mpv.enable` | boolean | `false` | Enable mpv. |
| `homeManager.applications.media.obs-studio.enable` | boolean | `false` | Enable OBS Studio with Plugins. |
| `homeManager.applications.media.vlc.enable` | boolean | `false` | Enable vlc. |
| `homeManager.applications.media.yt-dlp.enable` | boolean | `false` | Enable yt-dlp. |
