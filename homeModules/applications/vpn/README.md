# vpn

## Purpose

VPN clients.

## How it works

- Mullvad (account from sops) and Proton VPN.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.vpn.enable`. |
| `mullvad.nix` | Enable mullvad. |
| `protonvpn.nix` | Enable protonvpn. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.vpn.enable` | boolean | `false` | Enable vpn modules bundle. |
| `homeManager.applications.vpn.mullvad.enable` | boolean | `false` | Enable mullvad. |
| `homeManager.applications.vpn.protonvpn.enable` | boolean | `false` | Enable protonvpn. |
