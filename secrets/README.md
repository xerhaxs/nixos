# secrets

## Purpose

Legacy sops file shared by the home hosts (to be split, see `TODO.md`).

## How it works

- `.sops.yaml` defines which age keys can decrypt `secrets.yaml`.
- New hosts use one file per host in the private repository (`nixos.system.sops.perHostFile`).

## Contents

| Path | Description |
|---|---|
| `.sops.yaml` |  |
| `secrets.yaml` |  |

## Notes

- Edit: `sops secrets/secrets.yaml`, re-encrypt after key changes: `sops updatekeys secrets/secrets.yaml`.
