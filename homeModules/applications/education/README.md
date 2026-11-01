# education

## Purpose

Learning and reference applications (Kiwix, Stellarium).

## How it works

- Disabled by default.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.education.enable`. |
| `kiwix.nix` | Enable kiwix. |
| `stellarium.nix` | Enable stellarium. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.education.enable` | boolean | `false` | Enable education modules bundle. |
| `homeManager.applications.education.kiwix.enable` | boolean | `false` | Enable kiwix. |
| `homeManager.applications.education.stellarium.enable` | boolean | `false` | Enable stellarium. |
