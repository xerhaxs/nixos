# userEnvironment

## Purpose

Fonts and session variables of the user.

## How it works

- Enabled together with `nixos.userEnvironment`.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.userEnvironment.enable`. |
| `fonts.nix` | Enable fonts config. |
| `sessionVariables.nix` | Enable session variabels. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.userEnvironment.enable` | boolean | `false` | Enable userEnvironment modules bundle. |
| `homeManager.userEnvironment.fonts.enable` | boolean | `false` | Enable fonts config. |
| `homeManager.userEnvironment.sessionVariables.enable` | boolean | `false` | Enable session variabels. |
