# Updates and vulnerabilities

## Where versions are pinned

| What | Pin | Update |
|---|---|---|
| nixpkgs, Home Manager, flakes, blocklists | `flake.lock` | `nix flake update` |
| Grafana dashboards | `flake.lock`, URL with `revisions/latest` | `nix flake update` |
| Releases (dangerzone, briar-mailbox, weishaupt-webif-api-src, bluemap, fabric-api) | version in the URL in `flake.nix`, hash in `flake.lock` | change the URL, then `nix flake update <input>` |
| Commits (hyprgrass-src, wf-touch-src) | commit in the URL in `flake.nix`, hash in `flake.lock` | change the URL, then `nix flake update <input>` |
| Container images (ComfyUI, Networking Toolbox) | `pkgs/images.json` | `nix run .#update-images` |

A flake input cannot follow "the newest release", and `flake.lock` cannot hold registry digests. Registry images are therefore the only pins outside of `flake.lock`, and `update-images` keeps them in one file.

Downloads at runtime have no pin: the wine prefix of Fusion 360, the first start of Dangerzone (verified by cosign), Ollama models and the SDDM background.

## What runs where

| Unit | Host | Interval | Output in `/var/lib/prometheus-node-exporter` |
|---|---|---|---|
| `vulnscan` | all hosts | daily on servers, weekly on clients, only on AC power | `vulnscan.prom` |
| `nixos-version-metrics` | all hosts | hourly | `nixos-version.prom` |
| `update-check` | NixOS-Server1 | daily | `updates.prom` |

Prometheus collects the files through the textfile collector of the node exporter. Grafana shows them in the dashboard `Security und Updates`, Glance on the page `Server`.

## Reading the results

`vulnscan` builds an SBOM of the running system with sbomnix and matches it with grype. The vulnerability database is downloaded, nothing about the host is sent anywhere. It needs about 3.2 GB in `/var/cache/grype`, a scan takes about 3 minutes.

The findings are candidates. grype matches names and versions, it does not know the patches nixpkgs applies, so old CVEs show up for current packages. To check one: look it up in the nixpkgs package (`patches`), or on https://tracker.security.nixos.org. A false positive goes into `nixos.system.vulnscan.ignore`.

Alerts: new critical candidates, a scan older than 14 days, a pending reboot after 3 days, nixpkgs older than 21 days. The total of critical candidates does not alert, it would never be quiet.
