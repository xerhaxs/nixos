# userEnvironment

## Purpose

System parts of the user environment on desktops: games, I/O, fonts, browser policies, sync and network shares.

## How it works

- Enabled per host with `nixos.userEnvironment.enable`.

## Contents

| Path | Description |
|---|---|
| [`game/`](game/README.md) | Gaming: Steam, Gamemode and Gamescope. |
| [`io/`](io/README.md) | Input and output devices: audio, bluetooth, camera, input devices, printing and scanning. |
| `appimage.nix` | Enable appimage. |
| `chromium-policies.nix` | Enable chromium-policies. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.userEnvironment.enable`. |
| `fonts.nix` | Enable userEnvironment fonts. |
| `kdeconnect.nix` | Enable kdeconnect. |
| `mullvad.nix` | Enable mullvad vpn. |
| `networkshares.nix` | Enable mounting of networkshares. |
| `obs-studio.nix` | Enable obs-studio virtual camera module. |
| `syncthing.nix` | Enable Syncthing. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.userEnvironment.appimage.enable` | boolean | `false` | Enable appimage. |
| `nixos.userEnvironment.chromium-policies.enable` | boolean | `false` | Enable chromium-policies. |
| `nixos.userEnvironment.enable` | boolean | `false` | Enable userEnvironment modules bundle. |
| `nixos.userEnvironment.fonts.enable` | boolean | `false` | Enable userEnvironment fonts. |
| `nixos.userEnvironment.kdeconnect.enable` | boolean | `false` | Enable kdeconnect. |
| `nixos.userEnvironment.mullvad.enable` | boolean | `false` | Enable mullvad vpn. |
| `nixos.userEnvironment.networkshares.enable` | boolean | `false` | Enable mounting of networkshares. |
| `nixos.userEnvironment.networkshares.server` | string | `"NixOS-Server1"` | Hostname of the NAS providing the SMB shares. |
| `nixos.userEnvironment.networkshares.webdav.enable` | boolean | `false` | Mount the WebDAV share of NixOS-Server1 (dav.<homeDomain>) on /mount/dav (secret webdav-share/davfs). |
| `nixos.userEnvironment.networkshares.webdav.url` | string | `"https://dav.${config.nixos.site.homeDomain}/"` | URL of the WebDAV share. |
| `nixos.userEnvironment.obs-studio.enable` | boolean | `false` | Enable obs-studio virtual camera module. |
| `nixos.userEnvironment.syncthing.enable` | boolean | `false` | Enable Syncthing. |
