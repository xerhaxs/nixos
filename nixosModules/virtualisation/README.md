# virtualisation

## Purpose

Virtualisation and containers.

## How it works

- KVM/QEMU with libvirt, Android tools, Podman (Docker compatible, used by server containers) and Waydroid.

## Contents

| Path | Description |
|---|---|
| `android.nix` | Enable android. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.virtualisation.enable`. |
| `kvm.nix` | Enable kvm / qemu virtualisation. |
| `podman.nix` | Enable podman virtualisation. |
| `waydroid.nix` | Enable waydroid virtualisation. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.virtualisation.android.enable` | boolean | `false` | Enable android. |
| `nixos.virtualisation.enable` | boolean | `false` | Enable virtualisation modules bundle. |
| `nixos.virtualisation.kvm.enable` | boolean | `false` | Enable kvm / qemu virtualisation. |
| `nixos.virtualisation.podman.enable` | boolean | `false` | Enable podman virtualisation. |
| `nixos.virtualisation.waydroid.enable` | boolean | `false` | Enable waydroid virtualisation. |
