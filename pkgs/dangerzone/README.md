# dangerzone

## Purpose

Dangerzone built from source.

## How it works

- Python application with PySide6; resources and tessdata paths are patched to the Nix store, cosign is linked into `share/dangerzone/vendor`.
- The conversion image is downloaded and verified with cosign on first use and runs in rootless podman (`nixos.virtualisation.podman`).
- `ocrLanguages` selects the Tesseract languages (default eng, deu).

## Contents

| Path | Description |
|---|---|
| `package.nix` | Package definition. |

## Notes

- Update: change `version` and `hash` (`nix-prefetch-url --unpack https://github.com/freedomofpress/dangerzone/archive/refs/tags/v<version>.tar.gz`).
