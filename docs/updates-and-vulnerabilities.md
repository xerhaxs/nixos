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
| `clamdscan` (ClamAV) | all hosts | daily at 04:00, a missed run starts after the next boot | `clamav.prom` |
| `nixos-version-metrics` | all hosts | hourly | `nixos-version.prom` |
| `update-check` | NixOS-Server1 | daily | `updates.prom` |

Prometheus on NixOS-Server1 pulls the files every 30 seconds through the textfile collector of the node exporter (port 9100, in the LAN or through WireGuard). The clients send nothing themselves. The directory is persisted, a result survives a reboot. Grafana shows them in the dashboard `Security and Updates`, Glance on the page `Server`. For a host that is not reachable (a laptop that is off or away), the dashboard shows the last value of the past 14 days, reachable hosts show only their current values.

## Reading the results

`vulnscan` builds an SBOM of the running system with sbomnix and matches it with grype. The vulnerability database is downloaded, nothing about the host is sent anywhere. It needs about 3.2 GB in `/var/cache/grype`, a scan takes about 3 minutes.

The findings are candidates. grype matches names and versions, it does not know the patches nixpkgs applies, so old CVEs show up for current packages. To check one: look it up in the nixpkgs package (`patches`), or on https://tracker.security.nixos.org. A false positive goes into `nixos.system.vulnscan.ignore`.

Alerts: new critical candidates, a scan older than 14 days, malware found by ClamAV, a ClamAV scan older than 3 days, a pending reboot after 3 days, nixpkgs older than 21 days. The total of critical candidates does not alert, it would never be quiet.

## ClamAV

| What | When | Where |
|---|---|---|
| Scan of new and changed files (ctime newer than the last scan) | every night at 04:00, a missed run starts after the next boot | all hosts: `/home`, `/var/lib`, `/etc`, `/tmp`, `/var/tmp` and the extra directories of the host (Desktop `/mount/Data/Datein`, Server1 `/pool01/shares` without `video`) |
| Full scan of the same directories | on the 1st of the month (`fullScanDay`) or without a previous scan | all hosts |
| On-access scan, infected files cannot be opened | when a program opens a file | only clients: download directory and `/tmp/mozilla_<user>0` (attachments opened from Thunderbird) |

clamd uses at most 2 threads (`maxThreads`) with the lowest CPU and IO priority. On the clients it runs permanently for the on-access scan, on the servers it is started for the nightly scan and stopped afterwards (it holds the signatures in up to 3 GB of RAM). freshclam updates the signatures hourly.

A wrapper writes the number of infected files, the errors, the number of changed files, whether it was a full scan and up to 100 findings (path and signature) to `clamav.prom`. Exit code 1 means "found something" and does not mark the unit as failed, the alert `MalwareFound` reports it instead. `sudo systemctl start clamdscan` runs the mode of the day, `sudo clamdscan-metrics full` forces a full scan.

Findings can be false positives, for example in DLLs of Wine and DXVK. Look up the file hash (not the file) on VirusTotal before deleting anything.
