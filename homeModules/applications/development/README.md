# development

## Purpose

Development tools.

## How it works

- Editors (Kate, VSCodium), Bottles, diff and hex viewers, USB image writers, ESP/Raspberry Pi tools and VM viewers.

## Contents

| Path | Description |
|---|---|
| `bottles.nix` | Enable Bottles. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.development.enable`. |
| `diff.nix` | Enable diff tools. |
| `hex.nix` | Enable hex tools. |
| `imager.nix` | Enable imager tools. |
| `kate.nix` | Enable kate. |
| `singleboardcomputer.nix` | Enable Single-Board Computer software. |
| `virtualisation.nix` | Enable Virtualisation GUIs. |
| `vscodium.nix` | Enable VSCodium. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.development.bottles.enable` | boolean | `false` | Enable Bottles. |
| `homeManager.applications.development.diff.enable` | boolean | `false` | Enable diff tools. |
| `homeManager.applications.development.enable` | boolean | `false` | Enable development modules bundle. |
| `homeManager.applications.development.hex.enable` | boolean | `false` | Enable hex tools. |
| `homeManager.applications.development.imager.enable` | boolean | `false` | Enable imager tools. |
| `homeManager.applications.development.kate.enable` | boolean | `false` | Enable kate. |
| `homeManager.applications.development.singleboardcomputer.enable` | boolean | `false` | Enable Single-Board Computer software. |
| `homeManager.applications.development.singleboardcomputer.rpiImager` | boolean | `false` | Install the Raspberry Pi Imager. |
| `homeManager.applications.development.virtualisation.enable` | boolean | `false` | Enable Virtualisation GUIs. |
| `homeManager.applications.development.vscodium.enable` | boolean | `false` | Enable VSCodium. |

## Notes

- Ventoy is marked insecure in nixpkgs (prebuilt binary blobs) and explicitly allowed in `nixosModules/system/nixos.nix`.
