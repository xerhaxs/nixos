# base

## Purpose

Basic tools and shell programs available on every host.

## How it works

- The bundle `nixos.base.enable` enables bash, the common CLI tools, the console, git, tmux and vim.
- `common.nix` installs CLI tools for all hosts plus a small list only for hosts with a desktop (`nixos.desktop.enable`).

## Contents

| Path | Description |
|---|---|
| `bash.nix` | Enable Bash. |
| `common.nix` | Enable common tools. |
| `console.nix` | Enable console. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `nixos.base.enable`. |
| `git.nix` | Enable Git. |
| `tmux.nix` | Enable tmux. |
| `vim.nix` | Enable Vim. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `nixos.base.bash.enable` | boolean | `false` | Enable Bash. |
| `nixos.base.common.enable` | boolean | `false` | Enable common tools. |
| `nixos.base.console.enable` | boolean | `false` | Enable console. |
| `nixos.base.enable` | boolean | `false` | Enable base modules bundle. |
| `nixos.base.git.enable` | boolean | `false` | Enable Git. |
| `nixos.base.tmux.enable` | boolean | `false` | Enable tmux. |
| `nixos.base.vim.enable` | boolean | `false` | Enable Vim. |
