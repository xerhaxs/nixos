# hardware

## Purpose

CPU and GPU specific settings (microcode, drivers, video acceleration).

## How it works

- Hosts enable the matching modules, e.g. `nixos.hardware.amdcpu.enable`.

## Contents

| Path | Description |
|---|---|
| `amdcpu.nix` | Enable amdcpu support. |
| `amdgpu.nix` | Enable amdgpu support. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.hardware.enable`. |
| `intelcpu.nix` | Enable intelcpu support. |
| `intelgpu.nix` | Enable intelgpu support. |
| `nvidiagpu.nix` | Enable nvidiagpu support. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.hardware.amdcpu.enable` | boolean | `false` | Enable amdcpu support. |
| `nixos.hardware.amdgpu.enable` | boolean | `false` | Enable amdgpu support. |
| `nixos.hardware.enable` | boolean | `false` | Enable hardware modules bundle. |
| `nixos.hardware.intelcpu.enable` | boolean | `false` | Enable intelcpu support. |
| `nixos.hardware.intelgpu.enable` | boolean | `false` | Enable intelgpu support. |
| `nixos.hardware.nvidiagpu.enable` | boolean | `false` | Enable nvidiagpu support. |
