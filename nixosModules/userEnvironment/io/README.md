# io

## Purpose

Input and output devices: audio, bluetooth, camera, input devices, printing and scanning.

## How it works

- Audio (PipeWire), Bluetooth, camera, input devices (VIA, Xbox dongle) and printing/scanning (CUPS, SANE).
- `sane-extra-config.nix` adds the option `hardware.sane.extraConfig` for additional SANE backend settings.

## Contents

| Path | Description |
|---|---|
| `audio.nix` | Enable audio support |
| `bluetooth.nix` | Enable Bluetooth support. |
| `camera.nix` | Enable camera support |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.userEnvironment.io.enable`. |
| `input.nix` | Enable standard I/O settings. |
| `printing.nix` | Enable printing. |
| `sane-extra-config.nix` |  |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.userEnvironment.io.audio.enable` | boolean | `false` | Enable audio support |
| `nixos.userEnvironment.io.bluetooth.enable` | boolean | `false` | Enable Bluetooth support. |
| `nixos.userEnvironment.io.camera.enable` | boolean | `false` | Enable camera support |
| `nixos.userEnvironment.io.enable` | boolean | `false` | Enable io modules bundle. |
| `nixos.userEnvironment.io.input.enable` | boolean | `false` | Enable standard I/O settings. |
| `nixos.userEnvironment.io.printing.enable` | boolean | `false` | Enable printing. |
