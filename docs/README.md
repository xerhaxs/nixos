# docs

## Purpose

Background documents, evaluations and plans that are not tied to a single module folder.

## Contents

| File | Description |
|---|---|
| [`microphone.md`](microphone.md) | Rode Procaster on a Behringer UMC22: hardware setup and the EasyEffects chain. |
| [`updates-and-vulnerabilities.md`](updates-and-vulnerabilities.md) | Where versions are pinned, how to update them, CVE scan and update status in Grafana. |
| [`disaster-recovery.md`](disaster-recovery.md) | Data classes, backup copies, keys to keep offline, recovery per scenario, restore tests. |
| [`e2ee-and-runtime-protection.md`](e2ee-and-runtime-protection.md) | Why LUKS does not protect a running server, end-to-end encrypted options (Ente, Cryptomator, Syncthing untrusted devices) with pros and cons. |
| [`isolation.md`](isolation.md) | NixOS containers and microvm.nix for the exposed services, recommendation and example. |
| [`virtual-machines.md`](virtual-machines.md) | Declarative libvirt VMs with NixVirt: what it can and cannot do, Windows example. |
| [`offline-installation.md`](offline-installation.md) | Offline installer with prebuilt closures, local binary cache (harmonia, attic, Hydra). |
| [`providers.md`](providers.md) | Registrars (incl. Monero), DNS hosting, DDoS protection and VPS providers as Cloudflare replacement. |
| [`sms-gateway.md`](sms-gateway.md) | SIM card server with Gammu: use cases, risks, recommendation. |
| [`keepassxc-ssh-agent.md`](keepassxc-ssh-agent.md) | SSH keys in KeePassXC: setup and security assessment. |
| [`mail-pgp-jmap.md`](mail-pgp-jmap.md) | OpenPGP with Stalwart (WKD, encryption at rest), GnuPG, Thunderbird, JMAP clients. |
| [`proton-drive.md`](proton-drive.md) | Proton Drive backup through restic/rclone and access from the phone. |
| [`rss.md`](rss.md) | RSS: Miniflux, Fluent Reader on the clients, apps for the phone. |
| [`service-settings.md`](service-settings.md) | Which settings of each server service live in NixOS and which in the service itself. |
