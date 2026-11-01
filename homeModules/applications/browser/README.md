# browser

## Purpose

Web browsers.

## How it works

- LibreWolf: fingerprinting protection (FPP), WebGL only on request, no WebRTC IP leak, system DNS, uBlock Origin with cookie and annoyance lists, cookies of the own services survive the cleanup on shutdown.
- Brave: Chromium policies from `nixosModules/userEnvironment/chromium-policies.nix` (HTTPS-only, no telemetry, shields).
- Tor Browser is not modified on purpose, changes would make it distinguishable from other Tor users.

## Contents

| Path | Description |
|---|---|
| `brave.nix` | Enable brave browser. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.browser.enable`. |
| `librewolf.nix` | Enable librewolf browser. |
| `tor.nix` | Enable Tor browser. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.browser.brave.enable` | boolean | `false` | Enable brave browser. |
| `homeManager.applications.browser.enable` | boolean | `false` | Enable browser modules bundle. |
| `homeManager.applications.browser.librewolf.enable` | boolean | `false` | Enable librewolf browser. |
| `homeManager.applications.browser.tor.enable` | boolean | `false` | Enable Tor browser. |
