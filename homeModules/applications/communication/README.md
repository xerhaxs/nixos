# communication

## Purpose

Messengers, mail and voice.

## How it works

- Thunderbird with privacy settings (no user agent, anonymous HELO, simplified HTML, no JavaScript) and the accounts Proton (main, through the bridge), Stalwart, DLRG and 1&1 from the site data, Proton Mail Bridge, Discord, Briar, Element, Mumble, Signal, Telegram, Karere (WhatsApp).

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.communication.enable`. |
| `discord.nix` | Enable Discord. |
| `protonmail-bridge.nix` | Enable Protonmail bridge. |
| `social.nix` | Enable social communication apps. |
| `thunderbird.nix` | Enable Thunderbird. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.communication.discord.enable` | boolean | `false` | Enable Discord. |
| `homeManager.applications.communication.enable` | boolean | `false` | Enable communication modules bundle. |
| `homeManager.applications.communication.protonmail-bridge.enable` | boolean | `false` | Enable Protonmail bridge. |
| `homeManager.applications.communication.social.enable` | boolean | `false` | Enable social communication apps. |
| `homeManager.applications.communication.thunderbird.enable` | boolean | `false` | Enable Thunderbird. |
