# secrets

## Purpose

Legacy sops file shared by Desktop, Framework, Convertible and Server1, split into `clients.yaml` and `nixos-server1.yaml` of the private repository in TODO 7A, then deleted.

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
