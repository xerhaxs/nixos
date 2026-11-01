# fileshare

## Purpose

File shares in the home network (SMB and WebDAV).

## How it works

- `share.nix` creates the share directories, users and groups, `samba.nix` exports them (SMB3 only, encryption and signing required, only the LAN subnet), `webdav.nix` provides WebDAV behind nginx.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.server.fileshare.enable`. |
| `samba.nix` | Enable Samba file share. |
| `share.nix` | Enable file sharing systems. |
| `webdav.nix` | Enable Webdav file share. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.server.fileshare.enable` | boolean | `false` | Enable fileshare modules bundle. |
| `nixos.server.fileshare.samba.enable` | boolean | `false` | Enable Samba file share. |
| `nixos.server.fileshare.share.enable` | boolean | `false` | Enable file sharing systems. |
| `nixos.server.fileshare.share.path` | string | `"/srv/share"` | Set share path. |
| `nixos.server.fileshare.webdav.enable` | boolean | `false` | Enable Webdav file share. |
