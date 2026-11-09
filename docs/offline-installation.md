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

Plan (decision 08.11.2026, `TODO.md` 15.3): `NixOSInstaller.sh` is rebuilt to install from this image, and the image is rebuilt about every three months. Size measured on 08.11.2026: Desktop 51.5 GB, NixOS-Server1 23.1 GB, NixOS-ServerGaming 18.1 GB, NixOS-ServerPublic 9.0 GB per system, about 70-90 GB for all hosts because most packages are shared, compressed roughly 40-60 GB. The image must be written to a USB SSD (`isoImage` has no 4 GB limit on USB; or use `nixos-generators` format `raw-efi`). It contains the private input (domains, login hashes, encrypted sops files), so keep it private. The portable host already is such a medium for itself. nixos-anywhere from a client stays the recommended way to install.

Limits: the closures are frozen at build time; secrets (age key) still have to be copied by hand.

## 2. Local binary cache

Plan (`TODO.md` 15.3), with harmonia:

1. NixOS-Server1: a nightly systemd timer runs `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` for every host from the committed state of the repository (Syncthing already brings both repositories to `pool01/shares/jf`; updates stay manual, there is no `nix flake update` on the server). Only the current result per host is kept as GC root, older ones are collected; `keep-outputs = true` keeps the source tarballs so everything can be rebuilt if an upstream disappears.
2. `services.harmonia` on NixOS-Server1 with a signing key from sops, vhost `cache.<homeDomain>` (LAN/WireGuard only).
3. All hosts: `nix.settings.substituters = [ "https://cache.<homeDomain>" ]` before cache.nixos.org, `trusted-public-keys` with the harmonia key.
4. For a fully offline copy: `nix copy --to file:///mount/usb/cache <closures>` creates a binary cache directory on any disk, usable with `--option substituters file:///mount/usb/cache`.

Effect: rebuilds and installations in the home network work without internet for everything that was built the night before, and the sources stay available when upstream removes them. Git mirrors of all upstream projects (Forgejo) are not needed for this and were dropped on 08.11.2026.
