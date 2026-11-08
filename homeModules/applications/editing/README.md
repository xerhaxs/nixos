# editing

## Purpose

Graphics, video, audio, CAD and 3D editing.

## How it works

- The `compiler` module also refreshes the AACS key database for Blu-ray playback in VLC weekly over https.

## Contents

| Path | Description |
|---|---|
| `3dprinting.nix` | Enable 3D-printing tools. |
| `ai.nix` | Enable AI tools. |
| `blender.nix` | Enable blender |
| `compiler.nix` | Enable Media compiler tools. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.editing.enable`. |
| `gimp.nix` | Enable GIMP |
| `image.nix` | Enable image tools. |
| `kdenlive.nix` | Enable kdenlive |
| `tenacity.nix` | Enable tenacity |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.editing."3dprinting".enable` | boolean | `false` | Enable 3D-printing tools. |
| `homeManager.applications.editing.ai.enable` | boolean | `false` | Enable AI tools. |
| `homeManager.applications.editing.blender.enable` | boolean | `false` | Enable blender |
| `homeManager.applications.editing.compiler.enable` | boolean | `false` | Enable Media compiler tools. |
| `homeManager.applications.editing.enable` | boolean | `false` | Enable editing modules bundle. |
| `homeManager.applications.editing.gimp.enable` | boolean | `false` | Enable GIMP |
| `homeManager.applications.editing.image.enable` | boolean | `false` | Enable image tools. |
| `homeManager.applications.editing.kdenlive.enable` | boolean | `false` | Enable kdenlive |
| `homeManager.applications.editing.tenacity.enable` | boolean | `false` | Enable tenacity |
