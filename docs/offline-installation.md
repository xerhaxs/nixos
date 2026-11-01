# Offline installation and local binary cache

Two independent parts: an installation medium that contains everything a host needs (works without any network), and a local cache in the home network that makes normal rebuilds independent of cache.nixos.org and faster.

## 1. Offline installer (USB SSD)

Idea: an installer image whose `/nix/store` already contains the complete system closures of the hosts, plus the repository and the disko scripts. `nixos-install --system <closure>` then copies from the local store instead of downloading.

```nix
# hosts/NixOS-Installer (sketch)
{ config, pkgs, modulesPath, inputs, ... }:
let
  hosts = [ "NixOS-Desktop" "NixOS-Framework" "NixOS-Convertible" "NixOS-Server1" "NixOS-Portable" ];
  toplevel = h: inputs.self.nixosConfigurations.${h}.config.system.build.toplevel;
  disko = h: inputs.self.nixosConfigurations.${h}.config.system.build.diskoScript;
in {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  isoImage.storeContents = map toplevel hosts ++ map disko hosts;
  isoImage.contents = [ { source = inputs.self; target = "/nixos"; } ];
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
}
```

Install on a machine without network:

```
sudo /nix/store/<...>-disko --mode destroy,format,mount     # disko script of the host
sudo nixos-install --no-channel-copy --no-root-passwd --system /nix/store/<...>-nixos-system-NixOS-Desktop-...
```

The installer script (`NixOSInstaller.sh`) can detect the offline image and use the prebuilt paths. Size: the desktop closures are 30-60 GB, the image must be written to a USB SSD (`isoImage` has no 4 GB limit on USB; or use `nixos-generators` format `raw-efi`). The portable host already is such a medium for itself.

Limits: the closures are frozen at build time; secrets (age key) still have to be copied by hand.

## 2. Local binary cache

| Tool | What it does | Fit |
|---|---|---|
| harmonia | Serves the `/nix/store` of a host as binary cache, signs on the fly | Simplest: NixOS-Server1 builds all hosts nightly and serves its store |
| attic | Multi-tenant cache with deduplication and garbage collection, push with `attic push` | Good when several machines push, needs PostgreSQL and storage |
| nix-serve-ng | Like harmonia (older) | No advantage over harmonia |
| Hydra | Full CI that evaluates the flake and builds every job, with web UI | Powerful but heavy (PostgreSQL, evaluator RAM); only worth it for many jobs |
| ncps | Caching proxy in front of cache.nixos.org | Saves bandwidth, no own builds |

Recommendation:

1. NixOS-Server1: a nightly systemd timer runs `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` for every host (after `nix flake update` in a checkout of the repository) and keeps GC roots for the results.
2. `services.harmonia` on NixOS-Server1 with a signing key from sops, vhost `cache.<homeDomain>` (LAN/WireGuard only).
3. All hosts: `nix.settings.substituters = [ "https://cache.<homeDomain>" ]` before cache.nixos.org, `trusted-public-keys` with the harmonia key.
4. Optional: `ncps` as proxy for everything not built locally.
5. For a fully offline copy: `nix copy --to file:///mount/usb/cache <closures>` creates a binary cache directory on any disk, usable with `--option substituters file:///mount/usb/cache`.

Effect: rebuilds and installations in the home network work without internet for everything that was built the night before; the cache also keeps old versions available when upstream removes them.
