# base

## Purpose

Shell and CLI configuration of the user.

## How it works

- bash, btop, git, GnuPG, ranger, ssh, starship and vim.
- `gpg.nix`: GnuPG with WKD lookup and gpg-agent, imports the own public key from the private repository.
- `ssh.nix`: offers only the own key to the servers (they allow 3 attempts) and writes `~/.ssh/id_ed25519.pub` from `nixos.system.ssh.authorizedKeys` (comment `<user>@<host>`), the private key stays in KeePassXC.
- `persistent.nix` and `secrets.nix` keep the user data and the key directories (`.ssh`, `.gnupg`) on impermanence hosts. `.config/sops` is not kept, the sops admin key comes from KeePassXC.

## Contents

| Path | Description |
|---|---|
| `bash.nix` | Enable bash. |
| `btop.nix` | Enable btop. |
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.base.enable`. |
| `git.nix` | Enable git. |
| `gpg.nix` | Enable GnuPG with gpg-agent (keys are looked up by WKD first, the own public key is imported). |
| `persistent.nix` | Enable persistent. |
| `ranger.nix` | Enable ranger. |
| `secrets.nix` | Enable secrets |
| `ssh.nix` | Enable ssh. |
| `starship.nix` | Enable starship. |
| `vim.nix` |  |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.base.bash.enable` | boolean | `false` | Enable bash. |
| `homeManager.base.btop.enable` | boolean | `false` | Enable btop. |
| `homeManager.base.enable` | boolean | `false` | Enable base modules bundle. |
| `homeManager.base.git.enable` | boolean | `false` | Enable git. |
| `homeManager.base.gpg.enable` | boolean | `false` | Enable GnuPG with gpg-agent (keys are looked up by WKD first, the own public key is imported). |
| `homeManager.base.persistent.enable` | boolean | `false` | Enable persistent. |
| `homeManager.base.ranger.enable` | boolean | `false` | Enable ranger. |
| `homeManager.base.secrets.enable` | boolean | `false` | Enable secrets |
| `homeManager.base.ssh.enable` | boolean | `false` | Enable ssh. |
| `homeManager.base.starship.enable` | boolean | `false` | Enable starship. |
